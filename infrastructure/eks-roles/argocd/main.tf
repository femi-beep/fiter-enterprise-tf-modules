# ------------------------------------------------------------------------------
# IAM Assumable roles for ArgoCD service
# ------------------------------------------------------------------------------

module "iam_assumable_role_argo_cd" {
  source                       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                      = "4.1.0"
  create_role                  = true
  role_name                    = "${var.eks_cluster_name}-argoCD"
  provider_url                 = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns             = [
    aws_iam_policy.argo_cd.arn, "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  oidc_subjects_with_wildcards = ["system:serviceaccount:argocd:*"]
}

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
      "*",  # find a way to reduce to least privilege prefix
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

output "argocd_role_arn" {
  value = module.iam_assumable_role_argo_cd.iam_role_arn
}