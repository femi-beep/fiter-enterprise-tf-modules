locals {
  name = "${var.customer}-${var.environment}-vpc"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_tag = {
    "kubernetes.io/role/internal-elb" = 1
  }

  karpenter_tag = {
    "karpenter.sh/discovery" = "${var.customer}-${var.environment}"
    type                     = "private"
  }
  private_subnet_tags = var.enable_karpenter_autoscaler ? merge(local.private_tag, local.karpenter_tag) : local.private_tag
}