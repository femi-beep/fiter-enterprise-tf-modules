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
  description = "Storage Class to Use for Prometheus Metrics Storage"
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
