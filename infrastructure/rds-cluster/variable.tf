variable "db_identifier" {
  type        = string
  description = "Name of Database Identifier"
  validation {
    condition     = can(regex("^[0-9A-Za-z-]+$", var.db_identifier))
    error_message = "Username should only contain numbers, letters and underscores. Only Alphanumeric values and - are allowed"
  }
}

variable "engine" {
  description = "The database engine to use"
  default     = "postgres"
  validation {
    condition     = contains(["mysql", "postgres"], var.engine)
    error_message = "Object can Contain the Following postgres or mysql"
  }
}

variable "engine_version" {
  description = "Major engine verison of rds"
  default     = "16"
  type        = string
}

variable "username" {
  description = "Username for the root account of db"
  type        = string
  default     = "postgres"
}

variable "initial_db_name" {
  description = "Name of the db created initially"
  type        = string
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "Vpc to deploy the Cluster"
}

variable "monitoring_interval" {
  description = "Interval of monitoring"
  type        = number
  default     = 0
}

variable "create_monitoring_role" {
  description = "Flag to create monitoring role"
  default     = false
  type        = bool
}

variable "rds_family" {
  description = "RDS family like mysql, aurora with version"
  default     = "postgres16"
}

variable "vpc_availability_zones" {
  description = "List of availability zones in the VPC"
  type        = list(string)
}

variable "db_storage_size" {
  description = "Size of RDS storage in GB"
  default     = 100
  type        = number
}

variable "instance_class" {
  description = "Instance type for the cluster eg. db.t2.large"
  type        = string
}

variable "storage_type" {
  description = "Storage Type"
  default     = "io1"
  type        = string
}

variable "iops" {
  type        = number
  description = "IOPS to Provision"
  default     = 3000
}

variable "ca_cert_identifier" {
  default     = "rds-ca-rsa2048-g1"
  description = "See Certificate Authority on RDS Page"
  type        = string
}

variable "rds_db_delete_protection" {
  type        = bool
  description = "Whether aws rds/aurora database should have delete protection enabled"
  default     = true
}

variable "tags" {
  description = "Tags to be applied to the resources"
  type        = map(string)
  default     = {}
}

variable "disable_rds_public_access" {
  description = "Turn Off Public RDS Access"
  type        = bool
  default     = false
}

variable "allowed_cidrs" {
  description = "Allowed Cidrs in the Database"
  type = list(object({
    name        = string
    ip          = string
    description = string
    port        = optional(string, null)
  }))
  default = []
}

variable "subnets" {
  description = "List of subnets to use for the RDS cluster"
  type        = list(string)
}

variable "security_group_rules" {
  default = {}
}

