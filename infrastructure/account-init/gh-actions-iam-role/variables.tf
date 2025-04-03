variable "deployment_role_name" {
  type        = string
  description = "The name of the Terraform IAM deployment role"
}

variable "ci_pipelines_roles" {
  type        = map(any)
  description = "CI Policies to attach"
}
