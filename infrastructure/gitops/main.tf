data "aws_caller_identity" "current" {}

locals {
  setvalues = var.set_values_argocd_helm

  local_project = [
    {
      project_name          = var.eks_cluster_name
      project_description   = "Argocd Deployment Project"
      destination_namespace = "*"
      destination_server    = "https://kubernetes.default.svc"
    }
  ]
  client_projects = [
    for key, cluster in var.argocd_clients : {
      project_name          = "${key}"
      project_description   = "${cluster.name} Cluster Project"
      destination_namespace = "*"
      destination_server    = "${cluster.server}"
    }
  ]

  projects = concat(local.local_project, local.client_projects)

  eks_helm_map = {
    argocd_ingress_enabled      = var.argocd_ingress_enabled
    argocd_role_arn             = var.argocd_role_arn
    argocd_domain               = var.argocd_domain
    enable_argocd_notifications = var.enable_argocd_notifications
    argocd_server_replicas      = var.argocd_server_replicas
    argocd_server_pdb_enabled   = var.argocd_server_pdb_enabled
    argocd_server_min_pdb       = var.argocd_server_min_pdb
    projects                    = local.projects
  }
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = var.argocd_version
  chart      = "argo-cd"
  namespace  = var.k8s_namespace
  values = [
    templatefile("${path.module}/files/base-config.yaml", local.eks_helm_map)
  ]

  create_namespace = true
  dynamic "set" {
    for_each = { for set in local.setvalues : set.name => set }
    content {
      name  = set.key
      value = set.value.value
    }
  }
}

resource "helm_release" "argoapps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  version    = var.argoapps_version
  chart      = "argocd-apps"
  namespace  = var.k8s_namespace
  values = [
    templatefile("${path.module}/files/argocd-apps.yaml.tmpl", {
      applications = var.argocd_root_applications
      projects     = local.projects
    })
  ]
  create_namespace = true
  depends_on       = [helm_release.argocd]
}

# ------------------------------------------------------------------------------------------------
# Argocd Configurations
# ------------------------------------------------------------------------------------------------

resource "kubernetes_secret_v1" "default_cluster" {
  metadata {
    name      = "${var.eks_cluster_name}-cluster-secret"
    namespace = var.k8s_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
      clustername                      = var.eks_cluster_name
      environment                      = var.environment
      region                           = var.aws_region
    }
    annotations = var.cluster_labels
  }
  data = {
    name   = var.eks_cluster_name
    server = "https://kubernetes.default.svc"
    config = <<EOF
    {
      "tlsClientConfig" : {
        "insecure" : false
      }
    }
    EOF
  }


  depends_on = [helm_release.argocd]
}

resource "kubernetes_secret_v1" "argocd_clients" {
  for_each = var.argocd_clients
  metadata {
    name      = "${each.key}-cluster-secret"
    namespace = var.k8s_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }
  data = {
    name   = each.key
    server = each.value.server
    config = each.value.config
  }

  depends_on = [helm_release.argocd]
}

resource "kubernetes_secret_v1" "argocd_repositories" {
  for_each = var.argocd_repos
  metadata {
    name      = each.key
    namespace = var.k8s_namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    type          = each.value.type
    sshPrivateKey = each.value.generate_ssh ? tls_private_key.argocdsshkey[each.key].private_key_openssh : each.value.ssh_key
    url           = each.value.url
  }
  depends_on = [helm_release.argocd]
}

resource "kubernetes_secret" "argo_notification_secret" {
  count = var.enable_argocd_notifications ? 1 : 0
  metadata {
    name      = "argocd-notifications-secret"
    namespace = var.k8s_namespace
  }

  data = {
    slack-token = var.slack_token
  }
}

# ED25519 key
resource "tls_private_key" "argocdsshkey" {
  for_each  = { for key, value in var.argocd_repos : key => value if value.generate_ssh }
  algorithm = "ED25519"
}

resource "aws_ssm_parameter" "argocd_public_key" {
  for_each = { for key, value in var.argocd_repos : key => value if value.generate_ssh }
  name     = "/argocd/git/argocd-user/${var.eks_cluster_name}/${each.key}/github_public_sshkey"
  type     = "SecureString"
  value    = tls_private_key.argocdsshkey[each.key].public_key_openssh
}
