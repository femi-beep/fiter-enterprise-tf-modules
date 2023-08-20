data "aws_availability_zones" "available" {}

locals {
  name = "${var.customer}-${var.environment}-vpc"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_tag = {
    "kubernetes.io/role/internal-elb" = 1
  }

  karpenter_tag = {
    "karpenter.sh/discovery" = local.name
    type                     = "private"
  }
  private_subnet_tags = var.enable_karpenter_autoscaler ? merge(local.private_tag, local.karpenter_tag) : local.private_tag
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.name
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 52)]

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    type                     = "public"
  }

  private_subnet_tags = local.private_subnet_tags
  tags                = var.common_tags
}
