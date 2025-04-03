locals {
  db_port             = var.db_port
  publicly_accessible = var.disable_rds_public_access ? false : true
  tags = {
    Name    = var.db_identifier
    OwnedBy = "Terraform"
  }
  security_group_map = { for key in var.allowed_cidrs : key.name => key }
}