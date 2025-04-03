# Password resource
resource "random_password" "password" {
  count            = var.create_vpn_server ? 1 : 0
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}


resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "private_key_pem" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${var.ssh_key_path}/openvpn_ssh_key.pem"

  provisioner "local-exec" {
    command = "chmod 600 ${var.ssh_key_path}/openvpn_ssh_key.pem"
  }
}


# EC2 Instance
resource "aws_instance" "openvpn" {
  count                  = var.create_vpn_server ? 1 : 0
  ami                    = var.vpn_server_ami
  instance_type          = var.vpn_server_instance_type
  vpc_security_group_ids = var.create_vpn_server ? [aws_security_group.instance[0].id] : []
  subnet_id              = var.subnet_id
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash


              # /usr/local/openvpn_as/scripts/sacli --key "admin.user.name" --value "${var.vpn_server_username}" ConfigPut
              # /usr/local/openvpn_as/scripts/sacli --key "admin.user.password" --value "${random_password.password[0].result}" ConfigPut
              # /usr/local/openvpn_as/scripts/sacli --key "admin_ui.https.port" --value "${var.vpn_server_port}" ConfigPut
              # /usr/local/openvpn_as/scripts/sacli start

              admin_user=${var.vpn_server_username}
              admin_pw=${random_password.password[0].result}


              /usr/local/openvpn_as/scripts/sacli --key "vpn.server.dhcp_option.dns.0" --value ${var.private_dns_server} ConfigPut
              /usr/local/openvpn_as/scripts/sacli --key "vpn.server.dhcp_option.dns.1" --value "8.8.8.8" ConfigPut
              /usr/local/openvpn_as/scripts/sacli --key "vpn.server.dhcp_option.dns_server_to_client" --value "true" ConfigPut
              /usr/local/openvpn_as/scripts/sacli start
              
              # Install fail2ban
              apt-get update
              apt-get install -y fail2ban
              systemctl enable fail2ban
              systemctl start fail2ban

              # Change SSH port to 1002
              sed -i 's/#Port 22/Port 1002/' /etc/ssh/sshd_config
              sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
              sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
              systemctl restart sshd

              # Configure fail2ban for SSH
              cat <<EOT >> /etc/fail2ban/jail.local
              [sshd]
              enabled = true
              port = 1002
              logpath = %(sshd_log)s
              maxretry = 5
              EOT
              systemctl restart fail2ban
              EOF

  tags = merge(
    var.common_tags,
    {
      Name = "OpenVPN Server"
    }
  )
}


resource "aws_eip" "openvpn" {
  count    = var.create_vpn_server ? 1 : 0
  instance = aws_instance.openvpn[0].id
  domain   = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "OpenVPN-EIP"
    }
  )
}

# Security Group
resource "aws_security_group" "instance" {
  count       = var.create_vpn_server ? 1 : 0
  name_prefix = "openvpn-sg-"

  ingress {
    description = "SSh access to the OpenVPN server"
    from_port   = 1002
    to_port     = 1002
    protocol    = "tcp"
    cidr_blocks = var.vpn_authorized_access_cidr
  }

  vpc_id = var.vpn_vpc_id
  ingress {
    description = "Admin access to the OpenVPN server"
    from_port   = var.vpn_server_port
    to_port     = var.vpn_server_port
    protocol    = "tcp"
    cidr_blocks = var.vpn_authorized_access_cidr
  }

  ingress {
    description = "OpenVPN access to the OpenVPN server"
    from_port   = 1194 # Default OpenVPN port
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = var.vpn_authorized_access_cidr
  }

  egress {
    description = "All egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}
