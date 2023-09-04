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

variable "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
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

variable "vpc_private_subnets" {
  description = "AWS Subnets to Deploy Karpenter Nodes"
  type        = list(string)
}
