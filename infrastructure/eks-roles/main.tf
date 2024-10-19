resource "aws_iam_policy" "eks_apps_service_account_policy" {
  for_each    = var.additional_policies
  name        = "${var.eks_cluster_name}-${each.key}"
  description = "Permissions required by the Kubernetes Pods to access AWS Resources"
  policy      = "${file("${path.cwd}/${each.value.policy_file}")}"
}

module "eks_iam_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.1.0"
  for_each                      = local.enabled_service_accounts
  create_role                   = true
  role_name                     = each.value.role_name
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = each.value.role_policy_arn
  oidc_fully_qualified_subjects = strcontains(each.value.serviceaccount_name, "*") ? []: ["system:serviceaccount:${each.value.namespace}:${each.value.serviceaccount_name}"]
  oidc_subjects_with_wildcards  = strcontains(each.value.serviceaccount_name, "*") ? ["system:serviceaccount:${each.value.namespace}:${each.value.serviceaccount_name}"]: []
}


locals {
  eks_roles = {
    aws_alb = {
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
    external_dns = {
      role_name           = "${var.eks_cluster_name}-extDNS"
      namespace           = var.ca_k8s_namespace
      serviceaccount_name = var.ca_sa_name
      role_policy_arn     = [aws_iam_policy.external_dns.arn]
      enabled             = var.enable_external_dns
    },
    eks_log = {
      role_name           = "${var.eks_cluster_name}-eks-logs"
      namespace           = var.monitoring_namespace
      serviceaccount_name = var.monitoring_sa_name
      role_policy_arn     = [aws_iam_policy.eks_logger.arn]
      enabled             = var.enable_eks_log_bucket
    },
    external_secret = {
      role_name           = "${var.eks_cluster_name}-eks-external-secrets"
      namespace           = "kube-system"
      serviceaccount_name = var.external_secret_sa_name
      role_policy_arn     = [aws_iam_policy.external_secret.arn]
      enabled             = var.eks_external_secret_enabled
    }
  }

  additional_policies = {
    for key, value in var.additional_policies:
      key => {
        role_name           = "${var.eks_cluster_name}-${key}"
        namespace           = value.namespace
        serviceaccount_name = value.serviceaccount_name
        role_policy_arn     = [aws_iam_policy.eks_apps_service_account_policy[key].arn]
        enabled             = true
      }
  }

  enabled_service_accounts = { for key, value in merge(local.eks_roles, local.additional_policies) : key => value if value.enabled == true }
}