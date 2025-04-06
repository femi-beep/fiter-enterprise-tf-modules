data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# IAM Assumable roles for External Secret
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "external_secret" {
  statement {
    sid    = "SSMParameterReadOnly"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = [for parameter in var.parameter_store_prefixes : "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${parameter}/*"]
  }

  statement {
    sid    = "SecretsReadOnly"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]

    resources = [for secret in var.secret_prefixes : "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${secret}/*"]
  }

  statement {
    sid    = "PushSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:GetRandomPassword",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:PutResourcePolicy",
      "secretsmanager:PutSecretValue",
      "secretsmanager:RestoreSecret",
      "secretsmanager:RotateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:UpdateSecret",
      "secretsmanager:UpdateSecretVersionStage",
      "secretsmanager:ValidateResourcePolicy"
    ]
    resources = [for secret in var.secret_prefixes : "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${secret}/*"]
  }

  statement {
    sid    = "PushParameters"
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:AddTagsToResource",
      "ssm:ListTagsForResource"
    ]
    resources = [for parameter in var.parameter_store_prefixes : "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${parameter}/*"]
  }
}
