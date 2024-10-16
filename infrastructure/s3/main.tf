
module "s3_bucket" {
  source                    = "terraform-aws-modules/s3-bucket/aws"

  bucket                    = var.bucket_name
  acl                       = var.bucket_acl
  create_bucket             = var.create_bucket 

  control_object_ownership  = var.control_object_ownership
  object_ownership          = var.bucket_ownership
  force_destroy             = var.force_destroy 

  versioning = {
    enabled                 = var.enable_versioning
  }

  tags                      = var.tags
}

output "s3_bucket_arn" {
  value = module.s3_bucket.s3_bucket_arn
  
}