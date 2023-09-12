data "aws_caller_identity" "current" {
  
}

locals {
  eks_helm_map = {
    argocd_ingress_enabled = var.argocd_ingress_enabled
    argocd_role_arn        = var.argocd_role_arn
    argocd_domain          = var.argocd_domain
  }
  enable_argo_apps = !(length(var.argocd_root_applications) == 0 && length(var.argocd_root_projects) == 0)

  helm_releases = {
    argo-cd = {
      enabled          = true
      repository       = "https://argoproj.github.io/argo-helm"
      chart            = "argo-cd"
      version          = var.argocd_version
      namespace        = var.k8s_namespace
      create_namespace = true
      setvalues         = [] # annotations
      values = [
        templatefile("${path.module}/files/base-config.yaml", local.eks_helm_map),
        # templatefile("${path.module}/files/argocd/rbac-policy.yaml", local.eks_helm_map),
      ]
    },
    argocd-apps = {
      enabled          = local.enable_argo_apps
      repository       = "https://argoproj.github.io/argo-helm"
      chart            = "argocd-apps"
      version          = "0.0.9"
      namespace        = var.k8s_namespace
      create_namespace = true
      values = [
        templatefile("${path.module}/files/argocd-apps.yaml.tmpl", {
          applications = var.argocd_root_applications
          projects     = var.argocd_root_projects
        })
      ]
    }
  }
  enabled_helm_releases = { for key, value in local.helm_releases : key => value if value.enabled == true }
}

resource "helm_release" "this" {
  for_each = local.enabled_helm_releases

  name       = each.key
  repository = each.value.repository
  version    = each.value.version
  chart      = each.value.chart
  namespace  = each.value.namespace
  values     = each.value.values

  create_namespace = true
  dynamic "set" {
    for_each = {for set in lookup(each.value, "setvalues", []): set.name => set }
    content {
      name  = set.key
      value = set.value.value
    }
  }
}

# ------------------------------------------------------------------------------------------------
# Data Configurations
# ------------------------------------------------------------------------------------------------

data "aws_ssm_parameter" "cluster_certificate_data" {
  for_each = { for client in var.argocd_clients : client.name => client }
  name     = "/config/argocd/${var.eks_cluster_name}/${each.key}/certificate_data"
}

data "aws_ssm_parameter" "cluster_endpoint" {
  for_each = { for client in var.argocd_clients : client.name => client }
  name     = "/config/argocd/${var.eks_cluster_name}/${each.key}/endpoint"
}

# ------------------------------------------------------------------------------------------------
# Argocd Configurations
# ------------------------------------------------------------------------------------------------
resource "kubectl_manifest" "argocd_clients" {
  for_each = { for client in var.argocd_clients : client.name => client }
  yaml_body = templatefile("${path.module}/files/clusters.yaml.tmpl", {
    cluster_name             = each.key
    cluster_endpoint         = data.aws_ssm_parameter.cluster_endpoint[each.key].value
    argocd_client_role       = each.value.client_role_arn
    cluster_certificate_data = data.aws_ssm_parameter.cluster_certificate_data[each.key].value
    namespace                = var.k8s_namespace
  })
  depends_on = [helm_release.this]
}

resource "kubectl_manifest" "argocd_repositories" {
  for_each = { for repo in var.argocd_repos : repo.name => repo }
  yaml_body = templatefile("${path.module}/files/repository-external-secret.yaml", {
    repo_config_name = each.key
    aws_parameter    = each.value.aws_parameter
    github_url       = each.value.github_url
    namespace        = var.k8s_namespace
  })
  depends_on = [helm_release.this]
}

resource "kubectl_manifest" "argocd_oci_repositories" {
  for_each = toset(var.oci_repositories)
  yaml_body = templatefile("${path.module}/files/argo-oci-credentials.yaml", {
    oci_repository = each.key
    account_id     = data.aws_caller_identity.current.account_id
    region         = var.aws_region
    namespace      = var.k8s_namespace
  })
  depends_on = [helm_release.this]
}

data "kubectl_path_documents" "argocd_oci_serviceaccount" {
  pattern = "${path.module}/files/argo-credential-sa.yaml"
}

resource "kubectl_manifest" "argocd_oci_serviceaccount" {
  count      = length(var.oci_repositories) == 0 ? 0 : length(data.kubectl_path_documents.argocd_oci_serviceaccount.documents)
  yaml_body  = element(data.kubectl_path_documents.argocd_oci_serviceaccount.documents, count.index)
  depends_on = [helm_release.this]
}
