variable "k8s_namespace" {
  default = "monitoring"
}

variable "slack_enabled" {
  default = false
}

variable "slack_hook" {
  default = ""
  sensitive = true
}

variable "slack_channel" {
  default = ""
}

variable "prometheus_helm_version" {
  default = "36.0.2"
}

variable "loki_helm_version" {
  default = "2.9.10"
}

variable "storage_class_type" {
  default = "gp3"
}

variable "monitoring_ingress_enabled" {
  default = false
}

variable "monitoring_hostname" {
  default = ""
}

variable "eks_log_role" {
  
}

variable "eks_log_sa_name" {
  default = "eks-log-sa"
}

variable "eks_log_bucket" {
  
}

variable "eks_log_region" {
  
}