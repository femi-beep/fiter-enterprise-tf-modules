variable "role_name" {
  type        = string
  description = "Name of Role Name"
}

variable "description" {
  type        = string
  description = "Description of the IAM Role"
  default     = "IAM Role Managed by Terraform"
}

variable "common_tags" {
  type        = map(any)
  description = "Common Tags to be applied to the IAM Role"
}

variable "principal_type" {
  type        = string
  description = "Type of Principal"
  default     = "AWS"
}

variable "principal_identifiers" {
  type        = list(string)
  description = "List of Principal Identifiers"
  default     = []
}

variable "create_policy" {
  type        = bool
  description = "Create a Policy for the Role"
  default     = null
}

variable "role_policy" {
  type        = string
  default     = null
  description = "The IAM policy to attach to the role"
}

variable "policy_arns" {
  type        = set(string)
  default     = []
  description = "A set of policy ARNs to attach to the user"
}

variable "assume_policy" {
  type        = string
  default     = null
  description = "Assume Policy for the Role"
}