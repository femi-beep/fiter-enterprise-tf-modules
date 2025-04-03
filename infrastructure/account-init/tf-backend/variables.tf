variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket. Must be globally unique."
}

variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
}

variable "tf_backend_iam_principals" {
  type        = list(string)
  description = "AWS IAM principals identifiers"
  default     = []
}