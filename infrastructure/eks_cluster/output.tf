output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "node_security_group_ids" {
  value = module.eks.node_security_group_id
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "eks_log_bucket_arn" {
  value = module.eks_log_bucket.s3_bucket_arn
}

output "eks_log_bucket_name" {
  value = module.eks_log_bucket.s3_bucket_id
}

output "karpenter_role_arn" {
  value = module.karpenter.irsa_arn
}

output "karpenter_instance_profile" {
  value = module.karpenter.instance_profile_name
}