variable "eks_cluster_name" {
  description = "(Required) EKS Cluster Name"
}

variable "cluster_oidc_issuer_url" {
  description = "(Required) Cluster OIDC Url, in the format https://url. Provided as an output of the EKS module"
}

variable "k8s_namespace" {
  description = "(Optional) Namespace which ALB controller will be Deployed in"
  default = "kube-system"
}
