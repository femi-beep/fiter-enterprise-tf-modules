variable "customer" {
  description = "(Required) Name of Customer. ex: Fiter"
  type        = string
}

variable "environment" {
  description = "(Required) Environment e.g Dev, Stg, Prod"
  type = string
}

variable "vpc_cidr" {
  description = "(Required) VPC Cidr"
  type = string
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
  default = true
}