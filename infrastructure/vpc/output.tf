output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "List of IDs of private subnets"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "List of IDs of public subnets"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "The CIDR block of the VPC"
}

output "azs" {
  value       = module.vpc.azs
  description = "A list of availability zones specified as argument to this module"
}

output "intra_subnets" {
  value       = module.vpc.intra_subnets
  description = "Subnet ID for intra subnets"
}

output "private_route_table_ids" {
  value       = module.vpc.private_route_table_ids
  description = "Route Table ID's for the Private subnet"
}

output "nat_public_ips" {
  value       = module.vpc.nat_public_ips
  description = "Public IPs of the NAT Gateways"
}
