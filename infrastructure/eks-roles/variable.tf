variable "alb_k8s_namespace" {
  default     = "kube-system"
  type        = string
  description = "(Optional) Kubernetes Namespace for ALB Controller"
}

variable "alb_sa_name" {
  default     = "aws-alb-ingress-controller-sa"
  type        = string
  description = "(Optional) Kubernetes Service Account for ALB Controller"
}

variable "argocd_k8s_namespace" {
  default     = "argocd"
  type        = string
  description = "(Optional) Kubernetes Namespace for ArgoCd Controller"
}

variable "argocd_sa_name" {
  default     = "*"
  type        = string
  description = "(Optional) Kubernetes Service Account for ArgoCD Controller"
}

variable "ca_k8s_namespace" {
  default     = "kube-system"
  type        = string
  description = "(Optional) Kubernetes Namespace for Cluster Autoscaler Controller"
}


variable "ca_sa_name" {
  default     = "cluster-autoscaler-controller-sa"
  type        = string
  description = "(Optional) Kubernetes Service Account for Cluster Autoscaler Controller"
}

variable "ebs_k8s_namespace" {
  default     = "kube-system"
  type        = string
  description = "(Optional) Kubernetes Namespace for Cluster Autoscaler Controller"
}


variable "ebs_sa_name" {
  default     = "ebs-csi-controller-sa"
  type        = string
  description = "(Optional) Kubernetes Service Account for EBS CSI Controller"
}
variable "extDNS_k8s_namespace" {
  default     = "kube-system"
  type        = string
  description = "(Optional) Kubernetes Namespace for External DNS Controller"
}


variable "extDNS_sa_name" {
  default     = "external-dns-sa"
  type        = string
  description = "(Optional) Kubernetes Service Account for External DNS Controller"
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "(Required) OIDC URL for the Kubernetes Cluster"
}

variable "enable_alb_controller" {
  type        = bool
  description = "(Optional) Enable Creation of ALB Controller Role"
  default     = false
}

variable "enable_argocd" {
  type        = bool
  description = "(Optional) Enable Creation of ArgoCD Role"
  default     = false
}

variable "enable_cluster_autoscaler" {
  type        = bool
  description = "(Optional) Enable Creation of Cluster Autoscaler Role"
  default     = false
}

variable "enable_external_dns" {
  type        = bool
  description = "(Optional) Enable Creation of External DNS Role"
  default     = false
}

variable "eks_cluster_name" {
  type        = string
  description = "(Required) EKS Cluster Name"
}

variable "eks_log_bucket" {
  default     = ""
  description = "Bucket ARN to send EKS Logs"
  type        = string
}

variable "enable_eks_log_bucket" {
  default     = true
  description = "Enabled EKS Bucket Log Role"
  type        = bool
}

variable "monitoring_namespace" {
  default     = "monitoring"
  description = "Monitoring Namespace where Log System is deployed"
  type        = string
}

variable "monitoring_sa_name" {
  default     = "eks-log-sa"
  description = "Service Account Name for EKS logs"
  type        = string
}

variable "external_secret_sa_name" {
  default     = "*"
  description = "Service Account Name for External Secrets"
  type        = string
}

variable "eks_external_secret_enabled" {
  default     = true
  description = "Enable External Secrets IAM Role"
  type        = bool
}
