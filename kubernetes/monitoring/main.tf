locals {
  slack_hook_url = var.slack_enabled ? var.slack_hook : ""
  slack_channel  = var.slack_enabled ? var.slack_channel : ""
}

## Deploy Prometheus and Grafana via Helm charts
resource "helm_release" "prometheus_operator" {
  name             = "kube-prometheus-stack"
  chart            = "kube-prometheus-stack"
  version          = var.prometheus_helm_version
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = var.k8s_namespace
  cleanup_on_fail  = true
  create_namespace = true

  values = [templatefile(
    "${path.module}/values/prometheus.yaml", {
      SLACK_ENABLED : var.slack_enabled,
      SLACK_HOOK_URL : local.slack_hook_url,
      SLACK_CHANNEL : local.slack_channel,
      STORAGE_CLASS : var.storage_class_type,
      INGRESSENABLED : var.monitoring_ingress_enabled,
      INGRESSHOSTNAME : var.monitoring_hostname
  })]
}

# Logging Helm Chart
resource "helm_release" "loki" {
  name             = "loki-stack"
  chart            = "loki-stack"
  version          = var.loki_helm_version
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = var.k8s_namespace
  create_namespace = true
  cleanup_on_fail  = true


  values = [templatefile(
    "${path.module}/values/loki.yaml", {
      eks_log_role : var.eks_log_role,
      service_account_name : var.eks_log_sa_name,
      aws_bucket : var.eks_log_bucket,
      aws_region : var.eks_log_region
    }
  )]

  depends_on = [ helm_release.prometheus_operator ]
}


resource "kubernetes_config_map" "log_dashboard" {
  metadata {
    name      = "log-dashboard"
    namespace = var.k8s_namespace
    labels = {
      "grafana_dashboard" = "1"
    }
  }
  data = {
    "kubernetes_logs.json" = file("${path.module}/dashboards/kube-logs.json")
  }
  depends_on = [ helm_release.prometheus_operator ]
}

