data "aws_caller_identity" "current" {}

module "secrets_manager" {
  for_each = var.secrets
  source   = "terraform-aws-modules/secrets-manager/aws"

  # Secret
  name                    = "/kubernetes/${var.clustername}/${each.key}"
  description             = "Generated Secrets"
  recovery_window_in_days = 7

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"] #change to specific secret
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  # Version
  create_random_password           = true
  random_password_length           = each.value.passwordLength
  random_password_override_special = each.value.overridesSpecialChar

  tags = var.common_tags
}

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
  type = map(any)
  default = {}
}
