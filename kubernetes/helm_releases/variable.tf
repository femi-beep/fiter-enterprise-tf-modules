variable "cluster_autoscaler_enabled" {
  default     = false
  description = "Enable Cluster Autoscaler in Cluster"
  type        = bool
}

variable "cluster_autoscaler_version" {
  default     = "9.27.0"
  description = "Helm Chart Version for Cluster Autoscaler"
  type        = string
}

variable "metric_server_enabled" {
  default     = true
  description = "Enable Cluster Metrics Server"
  type        = bool
}

variable "metrics_server_version" {
  default     = "6.2.11"
  description = "Helm Chart Version for Metrics Server"
  type        = string
}

variable "cert_manager_enabled" {
  default     = false
  description = "Enable Cert Manager In Cluster, Not Needed if Running ALB Ingress"
  type        = bool
}

variable "cert_manager_version" {
  default     = "v1.8.0"
  description = "Helm Chart Version for Cert Manager"
  type        = string
}

variable "enable_cluster_issuer" {
  default     = false
  description = "Enable Cluster Issuer for Cert Manager"
  type        = bool
}

variable "nginx_ingress_enabled" {
  default     = false
  description = "Enable Nginx Ingress Controller Chart"
  type        = bool
}

variable "nginx_ingress_version" {
  default     = "4.7.1"
  description = "Helm Chart Version for Nginx Ingress Controller"
  type        = string
}

variable "alb_ingress_enabled" {
  default     = false
  description = "Enable AWS Application Load Balancer Ingress Controller (Specific to EKS Clusters)"
  type        = bool
}

variable "alb_ingress_version" {
  default     = "1.6.0"
  description = "Helm Chart Version for AWS Application LoadBalancer Controller"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to Deploy Loadbalancer for ALB ingress (Specific to AWS)"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of Kubernetes Cluster. Note. change to Cluster"
}

variable "enable_gp3_storage" {
  default     = false
  description = "Enable AWS GP3 Storage, Specific to EKS"
  type        = bool
}

variable "external_secret_enabled" {
  default     = false
  description = "Enable External Secrets Helm Release"
  type        = bool
}

variable "external_secret_version" {
  default     = "0.9.4"
  description = "Helm Version of External Secrets"
  type        = string
}
# "0.9.4"

variable "service_account_arns" {
  description = "Map of Arns from Service Accounts Module"
  type        = map(string)
}

variable "external_aws_secret_parameter_store_enabled" {
  default     = false
  description = "Enable AWS Parameter Store Integration"
  type        = bool
}

variable "external_aws_secret_manager_store_enabled" {
  default     = false
  description = "Enable AWS Secret Manager Store Integration"
  type        = bool
}

variable "external_secrets_namespace" {
  default     = "kube-system"
  description = "Kubernetes Namespace to Deploy External Secrets"
  type        = string
}