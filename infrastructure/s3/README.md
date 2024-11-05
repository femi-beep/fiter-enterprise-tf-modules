## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.27 |

## Modules

| Name | Type |
|------|------|
| [s3_bucket](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest) | resource |

## Resources

No Modules

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [registries\_name](#input\_registries\_name) | (Required) Name of the bucket to be created | `string` | `` | yes |
| <a name="input_create_bucket"></a> [registries\_name](#input\_registries\_name) | (Required) Whether to create a bucket or not | `bool` | `false` | no |
| <a name="input_registries_bucket_acl"></a> [registries\_name](#input\_registries\_name) | Value to indicate the access control for the bucket | `string` | `private` | no |
| <a name="input_registries_tags"></a> [registries\_name](#input\_registries\_name) | (Required) Tags to add to the bucket after created | `map` | `n/a` | yes |
| <a name="input_registries_bucket_ownership"></a> [registries\_name](#input\_registries\_name) | Ownership of items in bucket after creation | `string` | `ObjectWriter` | no |
| <a name="input_registries_control_object_ownership"></a> [registries\_name](#input\_registries\_name) | Value to control object ownership | `bool` | `true` | no |
| <a name="input_registries_force_destroy"></a> [registries\_name](#input\_registries\_name) | If deleting the bucket, destroy everything in it then delete it | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn_arn"></a> [s3\_s3_bucket_arn](#output\_s3\_s3_bucket_arn) | ARN of S3 Bucket |
| <a name="output_s3_bucket_id"></a> [s3\_s3_bucket_arn](#output\_s3\_s3_bucket_id) | S3 Bucket ID |
