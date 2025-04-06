# ------------------------------------------------------------------------------
# IAM Assumable roles for DNS service
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "external_dns" {
  statement {
    sid    = "ExternalDNSChange"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [for zone in var.hosted_zones : "arn:aws:route53:::hostedzone/${zone}"]
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
