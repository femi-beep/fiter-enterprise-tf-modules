module "eks_iam_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.1.0"
  for_each                      = { for key, value in local.eks_roles : key => value if value.enabled == true }
  create_role                   = true
  role_name                     = each.value.role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = each.value.role_policy_arn
  oidc_fully_qualified_subjects = ["system:serviceaccount:${each.value.namespace}:${each.value.serviceaccount_name}"]
}


locals {
  eks_roles = {
    alb = {
      role_name           = "${var.eks_cluster_name}-alb-controller"
      namespace           = var.alb_k8s_namespace
      serviceaccount_name = var.alb_sa_name
      role_policy_arn     = [aws_iam_policy.lb_controller.arn]
      enabled             = var.enable_alb_controller
    },
    argocd_controller = {
      role_name           = "${var.eks_cluster_name}-argoCD"
      namespace           = var.argocd_k8s_namespace
      serviceaccount_name = var.argocd_sa_name
      role_policy_arn     = [aws_iam_policy.argo_cd.arn, "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
      enabled             = var.enable_argocd
    },
    cluster_autoscaler = {
      role_name           = "${var.eks_cluster_name}-autoscaler"
      namespace           = var.ca_k8s_namespace
      serviceaccount_name = var.ca_sa_name
      role_policy_arn     = [aws_iam_policy.cluster_autoscaler.arn]
      enabled             = var.enable_cluster_autoscaler
    },
    external-dns = {
      role_name           = "${var.eks_cluster_name}-extDNS"
      namespace           = var.ca_k8s_namespace
      serviceaccount_name = var.ca_sa_name
      role_policy_arn     = [aws_iam_policy.external_dns.arn]
      enabled             = var.enable_external_dns
    },
  }
}

