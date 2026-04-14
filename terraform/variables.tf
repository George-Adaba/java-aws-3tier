variable "name" {
  description = "the name of the project"
  type = string
}
variable "cidr_block" {
  description = "the CIDR block for the VPC"
  type = string
}

variable "public_subnet_cidr" {
  type = list(string) 
}

variable "private_app_subnet" { 
  type = list(string) 
}

variable "private_db_subnet" { 
  type = list(string) 
}

variable "azs" { 
  type = list(string) 
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type = string
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1" 
}
