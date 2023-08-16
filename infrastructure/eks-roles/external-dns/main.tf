# ------------------------------------------------------------------------------
# IAM Assumable roles for DNS service
# ------------------------------------------------------------------------------
module "iam_assumable_role_external_dns" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.1.0"
  create_role                   = true
  role_name                     = "${var.eks_cluster_name}-extDNS"
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_dns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account}"]
}

resource "aws_iam_policy" "external_dns" {
  name_prefix = "${var.eks_cluster_name}-extDNS"
  description = "EKS external-dns policy for cluster ${var.eks_cluster_name}"
  policy      = data.aws_iam_policy_document.external_dns.json
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    sid    = "ExternalDNSChange"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = ["arn:aws:route53:::hostedzone/*"]
  }

  statement {
    sid    = "ExternalDNSList"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }
}