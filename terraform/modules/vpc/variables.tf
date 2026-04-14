# variable definitions for VPC module
variable "cidr_block" {
  description = "The IP address range for the VPC."
  type        = string
}

variable "name" {
  description = "The name of the project for tagging."
  type        = string
}

variable "public_subnet_cidr" {
    description = "list of cidr blocks for public subnets"
    type        = list(string)
}

variable "azs" {
    description = "list of availability zones for public subnets"
    type        = list(string)
}

variable "private_app_subnet" {
    description = "list of cidr blocks for private app subnets"
    type        = list(string)
}

variable "private_db_subnet" {
    description = "list of cidr blocks for private db subnets"
    type        = list(string)
}