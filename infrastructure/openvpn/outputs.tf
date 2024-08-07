output "openvpn_admin_password" {
  value       = var.create_vpn_server ? random_password.password[0].result : null
  sensitive   = true
  description = "The admin password for the OpenVPN server"
}

output "openvpn_admin_port" {
  value       = var.create_vpn_server ? var.vpn_server_port : null
  description = "The admin port for the OpenVPN server"
}

output "access_vpn_url" {
  value       = var.create_vpn_server ? "https://${aws_eip.openvpn[0].public_ip}:${var.vpn_server_port}/admin" : null
  description = "The public URL address of the VPN server admin interface"
}

output "client_vpn_url" {
  value       = var.create_vpn_server ? "https://${aws_eip.openvpn[0].public_ip}:${var.vpn_server_port}" : null
  description = "The public URL address of the client VPN server interface"
}
