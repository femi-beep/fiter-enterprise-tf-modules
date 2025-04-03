output "public_ip" {
  value       = var.associate_public_ip_address ? module.ec2.public_ip : ""
  description = "public ip address"
}
