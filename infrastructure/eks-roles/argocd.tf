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
  # for helm secrets vals
  #
  #  statement {
  #    actions   = ["ssm:GetParameter*"]
  #    resources = ["arn:aws:ssm:${var.aws_region}:${var.aws_account}:parameter/*"]
  #  }
  #
  #  statement {
  #    actions   = ["ssm:DescribeParameters"]
  #    resources = ["*"]
  #  }
}

# ED25519 key
resource "tls_private_key" "argocdsshkey" {
  count     = var.var.enable_argocd ? 1 : 0
  algorithm = "ED25519"
}

resource "aws_ssm_parameter" "argocd_private_key" {
  count = var.var.enable_argocd ? 1 : 0
  name  = "/argocd/git/argocd-user/${var.eks_cluster_name}/github_private_sshkey"
  type  = "SecureString"
  value = tls_private_key.argocdsshkey[0].private_key_openssh
}

resource "aws_ssm_parameter" "argocd_public_key" {
  count = var.var.enable_argocd ? 1 : 0
  name  = "/argocd/git/argocd-user/${var.eks_cluster_name}/github_public_sshkey"
  type  = "SecureString"
  value = tls_private_key.argocdsshkey[0].public_key_openssh
}
