output "arn" {
  value       = join("", aws_elasticache_replication_group.default[*].arn)
  description = "Elasticache Replication Group ARN"
}

output "id" {
  value       = join("", aws_elasticache_replication_group.default[*].id)
  description = "Redis cluster ID"
}

output "endpoint" {
  value       = var.cluster_mode_enabled ? join("", compact(aws_elasticache_replication_group.default[*].configuration_endpoint_address)) : join("", compact(aws_elasticache_replication_group.default[*].primary_endpoint_address))
  description = "Redis primary or configuration endpoint, whichever is appropriate for the given cluster mode"
}

output "reader_endpoint_address" {
  value       = join("", compact(aws_elasticache_replication_group.default[*].reader_endpoint_address))
  description = "The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled."
}

output "member_clusters" {
  value       = aws_elasticache_replication_group.default[*].member_clusters
  description = "Redis cluster members"
}

output "cluster_enabled" {
  value       = join("", aws_elasticache_replication_group.default[*].cluster_enabled)
  description = "Indicates if cluster mode is enabled"
}
