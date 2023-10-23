variable "k8s_namespace" {
  default     = "argocd"
  description = "Namespace to Deploy Argocd"
  type        = string
}

variable "aws_region" {
  description = "AWS Region to Where ECR Registry Resides"
  type        = string
}

variable "argocd_repos" {
  description = "List of Repository containing githuburl, name and type"
  type        = list(any)
  default     = []
}

variable "argocd_clients" {
  description = "List of Argocd Clients containing name and Client Role"
  type        = list(any)
  default     = []
}

variable "argocd_root_applications" {
  description = "List of Root Applications to Deploy"
  type        = list(any)
  default     = []
}

variable "argocd_ingress_enabled" {
  description = "Enable Argocd Ingress"
  type        = bool
  default     = false
}

variable "argocd_enabled" {
  description = "Deploy Argocd Helm"
  default     = false
  type        = bool
}

variable "argocd_role_arn" {
  description = "Argocd Service Account Role Arn"
  type        = string
  default     = ""
}

variable "argocd_domain" {
  description = "Argocd Host Domain"
  type        = string
}

variable "argocd_version" {
  default     = "5.17.1"
  description = "Version of Argocd Helm to Use"
  type        = string
}


variable "argocd_set_values" {
  default     = []
  description = "Arguement for setting Values in Helm Chart that are not passed in the values files"
  type        = list(any)
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of Kubernetes Cluster. Note. change to Cluster"
}

variable "ingress_class_name" {
  type        = string
  description = "Ingress Class Name for Argocd Ingress"
  default     = "nginx"
}

variable "ingress_cert_issuer" {
  type        = string
  description = "Cluster Issuer for Cert Manager to be used. Allows for custom"
  default     = "letsencrypt-prod-issuer"
}

variable "set_values_argocd_helm" {
  type        = list(any)
  description = "List of Set Command to Pass to Prometheus Helm Install"
  default     = []
}

variable "ingress_tls_enabled" {
  type        = bool
  description = "Enable Ingress TLS"
  default     = true
}

variable "enable_applicationset_controller" {
  type        = bool
  description = "Enable Applicationset Controller"
  default     = false
}

variable "enable_argocd_notifications" {
  type        = bool
  description = "Enable Argocd Notification"
  default     = false
}

variable "slack_token" {
  type        = string
  description = "Slack Token to Send Notifications"
  default     = ""
  sensitive   = true
}

variable "argocd_aws_ssm_ssh" {
  type        = string
  description = "AWS Parameter Name Where Argocd Secret is Stored"
}

variable "argo_ingress_class" {
  type        = string
  description = "Argocd Ingress Class to Use"
  default     = "nginx"
}