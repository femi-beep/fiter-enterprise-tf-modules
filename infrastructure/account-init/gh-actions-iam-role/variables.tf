variable "deployment_role_name" {
  description = "The name of the Terraform IAM deployment role"
  type        = string
}

variable "github_openidconnect_arn" {}

variable "bucket_name" {}

variable "table_name" {}

variable "ci_pipelines_roles" {
  type        = map(any)
  description = "CI Policies to attach"
}