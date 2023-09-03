resource "aws_iam_policy" "eks_logger" {
  name_prefix = "${var.eks_cluster_name}-loki"
  description = "EKS Bucket Logging policy for cluster ${var.eks_cluster_name}"
  policy      = data.aws_iam_policy_document.eks_logger.json
}

data "aws_iam_policy_document" "eks_logger" {
  statement {
    sid    = "AllowBucketLogging"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      var.eks_log_bucket,
      "${var.eks_log_bucket}/*"
    ]
  }
}