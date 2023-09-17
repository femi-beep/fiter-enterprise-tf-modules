locals {
  slack_hook_url = var.slack_enabled ? var.slack_hook : ""
  slack_channel  = var.slack_enabled ? var.slack_channel : ""
  setvalues      = var.ingress_class_name == "nginx" ? concat(local.nginx_annotations, var.set_values_prometheus_helm) : var.set_values_prometheus_helm
  nginx_annotations = [
    {
      name  = "grafana.ingress.annotations.cert-manager\\.io/cluster-issuer"
      value = var.ingress_cert_issuer
    }
  ]
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_secret" "grafana_password" {
  metadata {
    name      = "grafana-admin-secret"
    namespace = var.k8s_namespace
  }

  data = {
    admin-user     = "admin"
    admin-password = random_password.password.result
  }
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

  dynamic "set" {
    for_each = { for set in local.setvalues : set.name => set }
    content {
      name  = set.key
      value = set.value.value
    }
  }

  values = [templatefile(
    "${path.module}/values/prometheus.yaml", {
      SLACK_ENABLED : var.slack_enabled,
      SLACK_HOOK_URL : local.slack_hook_url,
      SLACK_CHANNEL : local.slack_channel,
      STORAGE_CLASS : var.storage_class_type,
      INGRESSENABLED : var.monitoring_ingress_enabled,
      INGRESSHOSTNAME : var.monitoring_hostname,
      INGRESSTLSENABLED : false,
      INGRESSCLASSNAME : "nginx",
      grafana_resources : var.grafana_resources,
      prom_operator_resources : var.prom_operator_resources,
      kube_state_resources : var.kube_state_resources,
      node_exporter_resources : var.node_exporter_resources,
      prometheus_resource_requests : var.prometheus_resource_requests,
      storage_class_type : var.storage_class_type,
      prometheus_storage_size : var.prometheus_storage_size,
  })]
  depends_on = [kubernetes_secret.grafana_password]
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
      loki_resources: var.loki_resources
      promtail_resources: var.promtail_resources
    }
  )]

  depends_on = [helm_release.prometheus_operator]
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
  depends_on = [helm_release.prometheus_operator]
}

