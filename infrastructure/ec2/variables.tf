variable "instance_type" {
  description = "Description: The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  default     = null
  type        = string
  description = "Key name of the Key Pair to use for the instance"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  default     = null
  type        = bool
}

variable "create_timeout" {
  default = "10m"
  type    = string
}

variable "delete_timeout" {
  default = "10m"
  type    = string
}

variable "ami_image_id" {
  type        = string
  default     = ""
  description = "ID of AMI to use for the instance"
}

variable "create_key_pair" {
  description = "Create AWS Key Pair, Set to False if Key already exists in AWS"
  type        = bool
  default     = false
}

variable "instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  default     = false
  type        = bool
}

variable "enable_hibernation_support" {
  default     = false
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
}

variable "create_security_group" {
  description = "Create EC2 Security Group, Set to False to Use Existing Security Group"
  default     = true
  type        = bool
}

variable "security_group_ids" {
  description = "List of Existing Security Groups to Use, Ignored if Create Security Group is enabled"
  default     = []
  type        = list(string)
}

variable "sg_ingress_cidr" {
  description = "List of CIDRs to Allow in Security Group, Defaults to the VPC CIDR if ignored."
  default     = []
  type        = list(string)
}

variable "sg_ingress_ports" {
  description = "List of Ingress Ports to Allow in Security Group"
  type        = list(number)
  default     = [80]
}

variable "sg_ingress_protocol" {
  description = "Ingress Protocol Name"
  default     = "tcp"
  type        = string
}

# variable "vpc_name" {
#   description = "VPC Name to Deploy EC2"
#   default     = "GetirKubeNetwork/K8SVPC"
#   type        = string
# }

variable "subnets" {
  description = "Name of VPC Subnets to Deploy EC2"
  type        = list(string)
}

variable "ebs_volume_size" {
  default     = 50
  description = "EBS Volume Size"
  type        = number
}

variable "ebs_volume_type" {
  default     = "gp3"
  description = "EBS Volume Type"
  type        = string
}

variable "enable_encrypted_volume" {
  default     = true
  description = "Enable EBS Volume Encryption"
  type        = bool
}

variable "instance_iam_policies" {
  default     = {}
  description = "Map of Policies to Add to Instance Profile"
  type        = map(any)
}

variable "additional_ebs_volumes" {
  type        = list(any)
  default     = []
  description = "List of Map of Additional EBS Volumes"
}

variable "tags" {
  type        = map(any)
  description = "Compulsory Tags For Terraform Resources, Must Contain Tribe, Squad and Domain"
}

variable "vpc_id" {

}
