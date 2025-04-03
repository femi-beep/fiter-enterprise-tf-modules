/*
 * # AWS ECR Terraform Module
 *
 * This module provisions multiple [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/) repositories on AWS.
 *
 * Features of this module:
 * - **ECR Repositories**: Automatically creates repositories for each name provided in the `registries_name` variable.
 * - **Encryption**: Each repository is configured with AES256 encryption to ensure secure storage of container images.
 * - **Image Scanning**: Image scanning is disabled by default (`scan_on_push = false`) but can be customized based on requirements.
 *
 * This module ensures security, scalability, and easy management of container image repositories for your workloads.
 *
 */

resource "aws_ecr_repository" "ecr" {
  for_each = toset(var.registries_name)
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "false"
  }

  image_tag_mutability = "MUTABLE"
  name                 = each.value
  force_delete         = true
}