variable "k8s_namespace" {
  default     = "monitoring"
  description = "Kubernetes Namespace to Deploy Monitoring Components"
  type        = string
}

variable "slack_enabled" {
  default     = false
  description = "Enable If Slack Hook is Provided. Acts as Destination for Alerts"
  type        = bool
}

variable "slack_hook" {
  default     = ""
  description = "Slack WebHook for Alerting. To Add Other Sources"
  sensitive   = true
  type        = string
}

variable "slack_channel" {
  default     = ""
  description = "Slack Channel to Send Alerts Notifications"
  type        = string
}

variable "prometheus_helm_version" {
  default     = "36.0.2"
  description = "Helm Chart Version for Kube Prometheus Stack"
  type        = string
}

variable "loki_helm_version" {
  default     = "2.9.10"
  description = "Helm Chart Version for Grafana Loki Stack"
  type        = string
}

variable "storage_class_type" {
  default     = "gp3"
  description = "Storage Class to Use for Prometheus Metrics Storage and Grafana"
  type        = string
}

variable "monitoring_ingress_enabled" {
  default     = false
  description = "Enable to Expose Grafana Chart to Internet, Requires a HostName"
  type        = bool
}

variable "monitoring_hostname" {
  default     = ""
  description = "HostName to Expose Grafana to Internet"
  type        = string
}

variable "eks_log_role" {
  description = "AWS Role ARN with Permission to Upload Logs to S3 Bucket"
  type        = string
}

variable "eks_log_sa_name" {
  default     = "eks-log-sa"
  description = "Name of Service Account that can Assume Log Role"
  type        = string
}

variable "eks_log_bucket" {
  description = "AWS Bucket to Send EKS Cluster Logs"
  type        = string
}

variable "eks_log_region" {
  description = "AWS Region where Log Bucket resides"
  type        = string
}

variable "grafana_resources" {
  type        = map(any)
  description = "Resources and Limits for Grafana Pod"
  default = {
    cpu_request = "100m"
    mem_request = "300Mi"
    mem_limit   = "500Mi"
  }
}

variable "grafana_storage_size" {
  type        = string
  description = "Storage Configuration map of Size and storage Class to use"
  default     = "10Gi"
}

variable "enable_grafana_storage" {
  type        = bool
  description = "Enable Grafana Storage"
  default     = false
}

variable "prometheus_resource_requests" {
  type        = string
  description = "Resource Request for Prometheus"
  default     = "400Mi"
}

variable "prometheus_storage_size" {
  type        = string
  description = "Size of Prometheus Storage"
  default     = "100Gi"
}

variable "node_exporter_resources" {
  type        = map(any)
  description = "Request and Limits for Node Exporter"
  default = {
    cpu_request = "50m"
    cpu_limit   = "200m"
    mem_request = "50Mi"
    mem_limit   = "200Mi"
  }
}

variable "prom_operator_resources" {
  type        = map(any)
  description = "Request and Limits for Prometheus Operator"
  default = {
    cpu_request = "50m"
    mem_request = "50Mi"
    mem_limit   = "200Mi"
  }
}

variable "kube_state_resources" {
  type        = map(any)
  description = "Request and Limits for Kube-State-Metrics"
  default = {
    cpu_request = "50m"
    mem_request = "50Mi"
    mem_limit   = "200Mi"
  }
}

variable "ingress_class_name" {
  type        = string
  description = "Ingress Class Name for Monitoring Ingress"
  default     = "nginx"
}

variable "set_values_prometheus_helm" {
  type        = list(any)
  description = "List of Set Command to Pass to Prometheus Helm Install"
  default     = []
}

variable "ingress_cert_issuer" {
  type        = string
  description = "Cluster Issuer for Cert Manager to be used. Allows for custom"
  default     = "letsencrypt-prod-issuer"
}

variable "promtail_resources" {
  type        = map(any)
  description = "Request and Limits for Promtail"
  default = {
    cpu_request = "100m"
    mem_request = "200Mi"
  }  
}

variable "loki_resources" {
  type        = map(any)
  description = "Request and Limits for Loki Resources"
  default = {
    cpu_request = "100m"
    mem_request = "200Mi"
  }
}