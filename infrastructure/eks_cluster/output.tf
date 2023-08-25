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