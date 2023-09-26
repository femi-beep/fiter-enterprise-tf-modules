output "db_instance_address" {
  value = module.db.db_instance_address
}

output "rds_secret" {
  value = {
    for key, secret in aws_lambda_invocation.db_service: key => lookup(jsondecode(secret.result), "secretname", "")
  }
}