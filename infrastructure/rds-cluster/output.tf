output "security_group_id" {
  description = "Security group ID for the RDS cluster"
  value       = module.aurora.security_group_id
}

output "cluster_endpoint" {
  description = "Cluster endpoint for the RDS cluster"
  value       = module.aurora.cluster_endpoint
}

output "admin_secret_arn" {
  description = "ARN of the admin secret in AWS Secrets Manager"
  value       = module.aurora.cluster_master_user_secret
}
