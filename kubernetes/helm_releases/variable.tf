variable "cluster_autoscaler_enabled" {
  default = false
}

variable "cluster_autoscaler_version" {
  default = "9.27.0"
}

variable "metric_server_enabled" {
  default = true
}

variable "metrics_server_version" {
  default = "6.2.11"
}

variable "cert_manager_enabled" {
  default = false
}

variable "cert_manager_version" {
  default = "v1.8.0"
}

variable "enable_cluster_issuer" {
  default = false
}

variable "nginx_ingress_enabled" {
  default = false
}

variable "nginx_ingress_version" {
  default = "4.7.1"
}

variable "alb_ingress_enabled" {
  default = false
}

variable "alb_ingress_version" {
  default = "1.6.0"
}

variable "vpc_id" {

}

variable "eks_cluster_name" {

}

variable "enable_gp3_storage" {
  default = true
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
