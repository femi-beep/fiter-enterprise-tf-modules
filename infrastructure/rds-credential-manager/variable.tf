variable "enable_credential_manager" {
  default     = true
  description = "Enable Credential Manager"
  type        = bool
}

variable "name" {
  type        = string
  description = "Name of the resource"
}

variable "engine" {
  description = "The database engine to use"
  default     = "postgres"
  validation {
    condition     = contains(["mysql", "postgres"], var.engine)
    error_message = "Object can Contain the Following postgres or mysql"
  }
}

variable "subnets" {
  description = "List of subnets to use for the RDS cluster"
  type        = list(string)
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with the RDS cluster"
}

variable "admin_secret_arn" {
  # type        = string
  description = "ARN of the admin secret in AWS Secrets Manager"
}

variable "database_host" {
  type        = string
  description = "Host of the database"
}

variable "database_admin_db" {

}

variable "database_identifier" {

}

variable "tags" {
  default = {}
}

variable "region" {

}

variable "db_service_users" {

}

variable "environment" {
  type        = string
  description = "Environment name"
}
