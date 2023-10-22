variable "deployment_role_name" {
  description = "The name of the Terraform IAM deployment role"
  type        = string
}

variable "github_openidconnect_arn" {}

variable "repo_list" {
  type        = list(string)
  description = "List of Repository to Grant Permission"
}

variable "bucket_name" {}

variable "table_name" {}