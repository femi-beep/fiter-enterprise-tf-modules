variable "ecr_token_username" {
  description = "Elastic Container Registry Token Username for Helm OCI Authentication"
  type        = string
}

variable "ecr_token_password" {
  description = "Elastic Container Registry Token Password for Helm OCI Authentication"
}

variable "karpenter_iam_role" {
  description = "Karpenter IRSA Role"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "instance_profile_name" {
  description = "Karpenter Nodes Instance Profile for AWS-AUTH"
  type        = string
}

variable "eks_node_security_group_id" {
  description = "EC2 Security Group to Attach to Karpenter Nodes"
  type        = string

}

variable "karpenter_queue_name" {
  description = "Karpenter SQS Queue Name"
  type        = string
}

variable "node_config" {
  description = "Node Configuration for Karpenter"
  type        = map(any)
  default     = {}
}

variable "use_custom_nodepool" {
  description = "Use Custom Nodepool"
  type        = bool
  default     = false
}

variable "custom_nodepool_path" {
  description = "Path to Custom Nodepool YAML"
  type        = string
  default     = "karpenter/nodepool.yaml"
}
