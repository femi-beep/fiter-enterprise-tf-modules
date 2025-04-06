# ------------------------------------------------------------------------------
# IAM Assumable roles for ArgoCD service
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "argo_cd" {
  # for helm secrets sops to decrypt using kms key
  statement {
    sid    = "argoAllowKMS"
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey",
      "kms:Decrypt*",
      "kms:Encrypt*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AssumeRoleArgo"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "*", # find a way to reduce to least privilege prefix
    ]

    effect = "Allow"
  }
}
