variable "registries_name" {
  type        = list(string)
  description = "(Required) List of ECR Registries to be created"
  default     = []
}