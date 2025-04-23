output "db_instance_address" {
  description = "value of the RDS instance address"
  value       = module.db.db_instance_address
}

output "rds_security_group" {
  description = "value of the RDS security group"
  value       = aws_security_group.service.id
}

output "db_instance_master_user_secret_arn" {
  description = "ARN of the master user secret in AWS Secrets Manager"
  value       = module.db.db_instance_master_user_secret_arn
}

output "db_identifier" {
  description = "Identifier for the database"
  value       = module.db.db_instance_identifier
}
