
variable "create_vpn_server" {
  description = "Whether to create the OpenVPN server resources"
  type        = bool
  default     = true
}

variable "vpn_server_username" {
  description = "Admin Username to access server"
  type        = string
  default     = "openvpn"
}

variable "vpn_server_port" {
  description = "Port to access server"
  type        = number
  default     = 943
}

variable "vpn_server_instance_type" {
  description = "Instance type to deploy server"
  type        = string
  default     = "t2.micro"
  
}

variable vpn_server_ami {
  description = "AMI to deploy server"
  type        = string
  default     = "ami-0b606792b54410645"
}

variable "vpn_authorized_access_cidr" {
  description = "CIDR block to allow access to VPN"
  type        = list(string)
  default     = ["0.0.0.0/0"]
  
}


variable "common_tags" {
  description = "(Required) Resource Tag"
  type        = map(any)
}

variable "vpn_vpc_id" {
  description = "VPC ID"
  type        = string
  
}

variable "subnet_id" {
  description = "The ID of the subnet where the OpenVPN server will be launched"
  type        = string
}

variable "ssh_key_path" {
  description = "Path to the SSH key to use for the OpenVPN server"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key to use for the OpenVPN server"
  type        = string
  default     = "openvpn_accessserver_key"
  
}

variable "private_dns_server"{
  type = string
  description = "value of the private dns server, should be based on vpc cidr"
  default = "172.16.0.2"
}

output "openvpn_setup_instructions" {
  value = <<-EOT
    OpenVPN Access Server has been deployed but requires manual setup:
    1. SSH into the instance:
       ssh -i /path/to/your/key.pem -p 1002 ubuntu@${var.create_vpn_server ? aws_eip.openvpn[0].public_ip : ""}
       or use the username set for openvpn
    2. Once connected, you can find the admin credentials in:
       /root/openvpn_admin_user.txt and /root/openvpn_admin_pass.txt
    3. Connect to the Admin UI: https://${var.create_vpn_server ? aws_eip.openvpn[0].public_ip : ""}:943/admin
    4. Log in with the credentials found in step 2.
    5. Accept the End-User License Agreement (EULA).
    6. Complete the initial setup wizard.
    7. Configure the server as needed for your environment.

    Note: The server won't be fully operational until these steps are completed.
    EOT
}