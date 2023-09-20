terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
}

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


variable "registries_name" {
  description = "(Required) List of ECR Registries to be created"
  default     = []
}