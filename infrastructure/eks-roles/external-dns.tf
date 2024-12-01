# ------------------------------------------------------------------------------
# IAM Assumable roles for DNS service
# ------------------------------------------------------------------------------
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

# to do restrict to specific dns names