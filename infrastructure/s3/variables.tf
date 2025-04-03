variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

}


variable "create_bucket" {
  description = "Whether to create the S3 bucket"
  type        = bool
  default     = false
}

variable "bucket_acl" {
  description = "The canned ACL to apply to the S3 bucket"
  type        = string
  default     = "private"
}


variable "tags" {
  description = "A map of tags to apply to the S3 bucket"
  type        = map(string)

}

variable "bucket_ownership" {
  description = "Whether to control ownership of objects in the bucket"
  type        = string
  default     = "ObjectWriter"

}


variable "enable_versioning" {
  description = "Whether to enable bucket versioning"
  type        = bool
  default     = true

}


variable "control_object_ownership" {
  description = "value to control object ownership"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = true
}