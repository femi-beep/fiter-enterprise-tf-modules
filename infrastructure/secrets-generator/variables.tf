variable "secrets" {
  type = map(object({
    passwordLength       = optional(number, 32)
    overridesSpecialChar = optional(string, "!#$%&*()-_=+[]{}<>:?")
  }))
  description = "Secrets to be generated"
  default     = {}
}

variable "clustername" {
  type        = string
  description = "Name of Kubernetes Cluster"
}

variable "common_tags" {
  type        = map(any)
  description = "Common tags to be applied to all resources"
  default     = {}
}

variable "secret_reader_arns" {
  type        = list(string)
  description = "List of ARNs that can read the secrets"
  default     = []
}
