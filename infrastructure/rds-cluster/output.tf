output "security_group_id" {
  value = module.aurora.security_group_id
}

output "cluster_endpoint" {
  value = module.aurora.cluster_endpoint
}

output "admin_secret_arn" {
  value = module.aurora.cluster_master_user_secret
}