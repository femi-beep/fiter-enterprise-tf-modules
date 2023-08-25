data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  eks_helm_map = {
    aws_region = data.aws_region.current.name
    vpc_id = var.vpc_id
    cluster_name = var.eks_cluster_name
    account_id = data.aws_caller_identity.current.account_id
  }
  helm_releases = {
    cluster-autoscaler = {
      enabled    = var.cluster_autoscaler_enabled
      repository = "https://kubernetes.github.io/autoscaler"
      chart      = "cluster-autoscaler"
      version    = var.cluster_autoscaler_version
      namespace  = "kube-system"
      values     = [templatefile("${path.module}/files/cluster-autoscaler.yaml", local.eks_helm_map)]
    },
    metrics-server = {
      enabled    = var.metric_server_enabled
      repository = "https://charts.bitnami.com/bitnami"
      chart      = "metrics-server"
      version    = var.metrics_server_version
      namespace  = "kube-system"
      values     = [templatefile("${path.module}/files/metrics-server.yaml", local.eks_helm_map)]
    },
    cert-manager = {
      enabled          = var.cert_manager_enabled
      repository       = "https://charts.jetstack.io"
      chart            = "cert-manager"
      version          = var.cert_manager_version
      namespace        = "cert-manager"
      create_namespace = true
      values           = [file("${path.module}/files/cert-manager.yaml")]
    },
      nginx_ingress = {
      enabled          = var.nginx_ingress_enabled
      repository       = "https://kubernetes.github.io/ingress-nginx"
      chart            = "ingress-nginx"
      version          = var.nginx_ingress_version
      namespace        = "kube-system"
      create_namespace = true
      values           = [file("${path.module}/files/nginx-ingress.yaml")]
    },
      alb_ingress = {
      enabled          = var.alb_ingress_enabled
      repository       = "https://aws.github.io/eks-charts"
      chart            = "aws-load-balancer-controller"
      version          = var.alb_ingress_version
      namespace        = "kube-system"
      create_namespace = true
      values           = [file("${path.module}/files/alb.yaml")]
    },
  }

  enabled_helm_releases = { for key, value in local.helm_releases: key => value  if value.enabled == true }
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
}

resource "kubernetes_manifest" "certbot_prod" {
  count = var.cert_manager_enabled ? 1 : 0
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-prod-issuer"
    }
    "spec" = {
      "acme" = {
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-prod"
        }
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          },
        ]
      }
    }
  }
  depends_on = [helm_release.this]
}

# ------------------------------------------------------------------------------------------------
# Storage Class changes (make gp2 not default, add gp3 as default, and gp3-kms-enc for encrypted
# ------------------------------------------------------------------------------------------------
# gp3 storage class for cheaper storage
resource "kubernetes_manifest" "gp3" {
  count = var.enable_gp3_storage ? 1 : 0
  manifest = {
    "apiVersion" = "storage.k8s.io/v1"
    "kind"       = "StorageClass"
    "metadata" = {
      "name" = "gp3"
    }
    "provisioner": "ebs.csi.aws.com"
    "parameters" = {
      "fsType" = "ext4"
      "type" = "gp3"
    }
    "reclaimPolicy" = "Delete"
    "allowVolumeExpansion" = true
  }
}