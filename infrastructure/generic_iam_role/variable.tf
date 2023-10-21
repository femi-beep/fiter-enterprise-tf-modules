variable "policy_file" {
  description = "Name of Policy File to Find IAM Role. Found in the current Working Directory"
  type        = string
}

variable "role_name" {
  description = "Name of Role Name"
  type        = string
}
variable "customer" {
  description = "Name of Customer"
  type        = string
}
variable "environment" {}

variable "common_tags" {}

variable "assume_role_arn" {
  description = "ARN of Role or User which can Assume this role"
}
