locals {
  eks_roles = {
    aws_alb = {
      role_name           = "${var.eks_cluster_name}-alb-controller"
      namespace           = var.alb_k8s_namespace
      serviceaccount_name = var.alb_sa_name
      role_policy_json    = file("${path.module}/permissions/alb.json")
      enabled             = var.enable_alb_controller
    },
    argocd_controller = {
      role_name           = "${var.eks_cluster_name}-argoCD"
      namespace           = var.argocd_k8s_namespace
      serviceaccount_name = var.argocd_sa_name
      role_policy_json    = data.aws_iam_policy_document.argo_cd.json
      enabled             = var.enable_argocd
    },
    cluster_autoscaler = {
      role_name           = "${var.eks_cluster_name}-autoscaler"
      namespace           = var.ca_k8s_namespace
      serviceaccount_name = var.ca_sa_name
      role_policy_json    = data.aws_iam_policy_document.cluster_autoscaler.json
      enabled             = var.enable_cluster_autoscaler
    },
    external_dns = {
      role_name           = "${var.eks_cluster_name}-extDNS"
      namespace           = var.extDNS_k8s_namespace
      serviceaccount_name = var.extDNS_sa_name
      role_policy_json    = data.aws_iam_policy_document.external_dns.json
      enabled             = var.enable_external_dns
    },
    eks_log = {
      role_name           = "${var.eks_cluster_name}-eks-logs"
      namespace           = var.monitoring_namespace
      serviceaccount_name = var.monitoring_sa_name
      role_policy_json    = data.aws_iam_policy_document.eks_logger.json
      enabled             = var.enable_eks_log_bucket
    },
    external_secret = {
      role_name           = "${var.eks_cluster_name}-eks-external-secrets"
      namespace           = "kube-system"
      serviceaccount_name = var.external_secret_sa_name
      role_policy_json    = data.aws_iam_policy_document.external_secret.json
      enabled             = var.eks_external_secret_enabled
    }
  }

  additional_policies = {
    for key, value in var.additional_policies :
    key => {
      role_name           = "${var.eks_cluster_name}-${key}"
      namespace           = value.namespace
      serviceaccount_name = value.serviceaccount_name
      role_policy_json    = value.role_policy_json
      enabled             = true
    }
  }
  enabled_service_accounts = { for key, value in merge(local.eks_roles, local.additional_policies) : key => value if value.enabled == true }
  provider_url             = replace(var.cluster_oidc_issuer_url, "https://", "")
}
