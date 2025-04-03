variable "instance_type" {
  type        = string
  description = "Description: The type of instance to start"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Key name of the Key Pair to use for the instance"
  default     = null
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP address with an instance in a VPC"
  default     = null
}

variable "create_timeout" {
  type        = string
  description = "value of the timeout to create the resource"
  default     = "10m"
}

variable "delete_timeout" {
  type        = string
  description = "value of the timeout to delete the resource"
  default     = "10m"
}

variable "ami_image_id" {
  type        = string
  description = "ID of AMI to use for the instance"
  default     = ""
}

variable "create_key_pair" {
  type        = bool
  description = "Create AWS Key Pair, Set to False if Key already exists in AWS"
  default     = false
}

variable "instance_name" {
  type        = string
  description = "Name to be used on EC2 instance created"
}

variable "disable_api_termination" {
  type        = bool
  description = "If true, enables EC2 Instance Termination Protection"
  default     = false
}

variable "enable_hibernation_support" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = false
}

variable "create_security_group" {
  type        = bool
  default     = true
  description = "Create EC2 Security Group, Set to False to Use Existing Security Group"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of Existing Security Groups to Use, Ignored if Create Security Group is enabled"
  default     = []
}

variable "sg_ingress_cidr" {
  type        = list(string)
  description = "List of CIDRs to Allow in Security Group, Defaults to the VPC CIDR if ignored."
  default     = []
}

variable "sg_ingress_ports" {
  type        = list(number)
  description = "List of Ingress Ports to Allow in Security Group"
  default     = [80]
}

variable "sg_ingress_protocol" {
  type        = string
  description = "Ingress Protocol Name"
  default     = "tcp"
}

# variable "vpc_name" {
#   description = "VPC Name to Deploy EC2"
#   default     = "GetirKubeNetwork/K8SVPC"
#   type        = string
# }

variable "subnets" {
  type        = list(string)
  description = "Name of VPC Subnets to Deploy EC2"
}

variable "ebs_volume_size" {
  type        = number
  description = "EBS Volume Size"
  default     = 50
}

variable "ebs_volume_type" {
  type        = string
  description = "EBS Volume Type"
  default     = "gp3"
}

variable "enable_encrypted_volume" {
  type        = bool
  description = "Enable EBS Volume Encryption"
  default     = true
}

variable "instance_iam_policies" {
  type        = map(any)
  description = "Map of Policies to Add to Instance Profile"
  default     = {}
}

variable "additional_ebs_volumes" {
  type        = list(any)
  description = "List of Map of Additional EBS Volumes"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "Compulsory Tags For Terraform Resources, Must Contain Tribe, Squad and Domain"
}

variable "vpc_id" {

}
