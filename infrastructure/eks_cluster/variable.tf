variable "customer" {
  description = "(Required) Name of Customer. ex: Fiter"
  type        = string
}

variable "environment" {
  description = "(Required) Environment e.g Dev, Stg, Prod"
  type        = string
}

variable "cluster_version" {
  description = "AWS EKS Cluster Version"
  default     = "1.25"
  type        = string
}
# variable "cluster_encryption_key_arn" {} # aws_kms_key.k8s_secrets.arn. can be reused?
variable "common_tags" {
  description = "(Required) Resource Tag"
  type        = map(any)
}

variable "node_groups_attributes" {
  description = "Node Group Properties. Used to Provision EKS node groups"
  type        = map(any)
}

variable "node_security_group_additional_rules" {}

variable "vpc_id" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
}
variable "subnets" {
  description = "A list of subnet IDs where the nodes/node groups will be provisioned."
  type        = list(string)
}

variable "aws_auth_users" {
  description = "List of User maps to add to the aws-auth configmap"
  type        = list(any)
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  default     = []
  type        = list(any)
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled, set to False to enable only private access via VPN"
  default     = true
  type        = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}


variable "eks_logging_bucketname" {
  default     = "eks-logs"
  description = "AWS Bucket Name to Send EKS Logs"
}

variable "assume_role_arn" {
  description = "Terraform Role to Assume"
  type        = string
  default     = ""
}
