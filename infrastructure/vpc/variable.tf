variable "customer" {
  description = "(Required) Name of Customer. ex: Fiter"
  type        = string
}

variable "environment" {
  description = "(Required) Environment e.g Dev, Stg, Prod"
  type        = string
}

variable "vpc_cidr" {
  description = "(Required) VPC Cidr"
  type        = string
}



variable "common_tags" {
  description = "(Required) Resource Tag"
  type        = map(any)
}

variable "enable_nat_gateway" {
  description = "(Optional) Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
  type        = bool
}

variable "single_nat_gateway" {
  description = "(Optional) Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = true
  type        = bool
}

variable "enable_karpenter_autoscaler" {
  description = "Enabled Karpenter Autoscaler"
  default = true
}

variable "enable_secretmanager_vpc_endpoint" {
  description = "Enable SecretsManager VPC Endpoint if DB is in Private Subnet"
  type        = bool
}

variable "enable_private_zone" {
  description = "Enable Private Route53 Zone"
  type        = bool
  default     = false
}

variable "private_zone_host_name" {
  description = "Private Route53 Zone Host Name"
  type        = string
  default     = "fineract.internal"
  
}