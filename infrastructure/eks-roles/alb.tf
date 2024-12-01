# ------------------------------------------------------------------------------
# IAM Assumable roles for aws-lb-controller-service
# ------------------------------------------------------------------------------
resource "aws_iam_policy" "lb_controller" {
  name        = "${var.eks_cluster_name}-alb-controller"
  path        = "/"
  description = "Policy for alb-ingress service"

  policy = file("${path.module}/permissions/alb.json")
}

