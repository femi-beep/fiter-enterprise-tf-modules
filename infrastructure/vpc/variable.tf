variable "customer" {
  type        = string
  description = "(Required) Name of Customer. ex: Fiter"
}

variable "environment" {
  type        = string
  description = "(Required) Environment e.g Dev, Stg, Prod"
}

variable "vpc_cidr" {
  type        = string
  description = "(Required) VPC Cidr"
}



variable "common_tags" {
  type        = map(any)
  description = "(Required) Resource Tag"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "(Optional) Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "(Optional) Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = true
}

variable "enable_karpenter_autoscaler" {
  type = bool
  description = "Enabled Karpenter Autoscaler"
  default = true
}

variable "enable_secretmanager_vpc_endpoint" {
  type        = bool
  description = "Enable SecretsManager VPC Endpoint if DB is in Private Subnet"
}
