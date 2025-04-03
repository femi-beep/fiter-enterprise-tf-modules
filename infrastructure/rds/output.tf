output "db_instance_address" {
  description = "value of the RDS instance address"
  value       = module.db.db_instance_address
}

output "rds_secret" {
  description = "RDS secret"
  value = {
    for key, secret in aws_lambda_invocation.db_service : key => lookup(jsondecode(secret.result), "secretname", "")
  }
}
