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
  value = module.karpenter.iam_role_arn
}

output "karpenter_instance_profile" {
  value = module.karpenter.instance_profile_name
}

output "karpenter_queue_name" {
  value = module.karpenter.queue_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

# temp support to error from aws-auth module
output "aws_auth_configmap_data" {
  value = {
    mapRoles    = yamlencode(local.eks_auth_roles)
    mapUsers    = yamlencode(local.eks_auth_users)
    mapAccounts = yamlencode([])
  }
}