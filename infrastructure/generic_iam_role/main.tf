/*
 * # AWS IAM Role Terraform Module
 *
 * This module creates a **generic AWS IAM Role** with associated policies.
 *
 * ## Features:
 * - Creates an IAM role with a formatted name.
 * - Configures a trust policy to allow role assumption via `principal_type` and `principal_identifiers`.
 * - Renders and attaches a custom policy from a template.
 * - Supports tagging with `common_tags`.
 *
 * ## Outputs:
 * - **`argo_client_arn`**: ARN of the created IAM role.
 *
 * ## Resources:
 * - IAM Role, IAM Policy, and Role-Policy Attachment.
*/

locals {
  assume_policy = var.assume_policy != null ? var.assume_policy : data.aws_iam_policy_document.default.json
  create_policy = var.create_policy != null ? var.create_policy : var.role_policy != null
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = var.principal_type
      identifiers = var.principal_identifiers
    }
  }
}

resource "aws_iam_role" "generic_role" {
  name        = "${var.role_name}-role"
  description = var.description

  tags = var.common_tags

  force_detach_policies = true

  assume_role_policy = local.assume_policy
}

resource "aws_iam_role_policy" "generic_policy" {
  count  = var.create_policy ? 1 : 0
  name   = "${var.role_name}-policy"
  policy = var.role_policy
  role   = aws_iam_role.generic_role.id
}

resource "aws_iam_role_policy_attachment" "generic_policy_attachment" {
  for_each   = var.policy_arns
  role       = aws_iam_role.generic_role.name
  policy_arn = each.value
}
