# ------------------------------------------------------------------------------
# IAM Assumable roles for ArgoCD service
# ------------------------------------------------------------------------------
resource "aws_iam_policy" "argo_cd" {
  name_prefix = "${var.eks_cluster_name}-argoCD"
  description = "EKS argocd policy for cluster ${var.eks_cluster_name}"
  policy      = data.aws_iam_policy_document.argo_cd.json
}

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
