variable "k8s_namespace" {
  default     = "argocd"
  description = "Namespace to Deploy Argocd"
  type        = string
}

variable "aws_region" {
  description = "AWS Region to Where ECR Registry Resides"
  type        = string
}

variable "oci_repositories" {
  description = "List of OCI Repositories"
  type        = list(any)
  default     = []
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

variable "argocd_root_projects" {
  description = "List of Root Projects"
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
  default = ""
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
  default = []
  description = "Arguement for setting Values in Helm Chart that are not passed in the values files"
  type = list(any)
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of Kubernetes Cluster. Note. change to Cluster"
}