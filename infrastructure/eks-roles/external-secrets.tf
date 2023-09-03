data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# IAM Assumable roles for External Secret
# ------------------------------------------------------------------------------
resource "aws_iam_policy" "external_secret" {
  name_prefix = "${var.eks_cluster_name}-ExternalSecrets"
  description = "EKS Secrets policy for cluster ${var.eks_cluster_name}"
  policy      = data.aws_iam_policy_document.external_secret.json
}

data "aws_iam_policy_document" "external_secret" {
  statement {
    sid    = "SSMParameterReadOnly"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "SecretsReadOnly"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "kms:Decrypt"
    ]

    resources = ["arn:aws:secretsmanager:${data.aws_caller_identity.current.account_id}:*"]
  }
}