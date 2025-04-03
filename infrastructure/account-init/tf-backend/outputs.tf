output "terraform_bucket_name" {
  value       = aws_s3_bucket.tf_bucket.id
  description = "value terraform bucket name"
}

output "terraform_dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_lock.id
  description = "value for terraform dynamodb table name"
}
