# variable definitions for security groups module
variable "name" {
    description = "The name of the project for tagging."
    type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC where the security groups will be created."
    type        = string
  }

variable "vpc_cidr" {
    description = "The CIDR block of the VPC, used for security group rules."
    type        = string
  }