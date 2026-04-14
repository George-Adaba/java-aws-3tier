variable "name" {
  description = "the name of the project"
  type = string
}

variable "ami_id" {
  description = "the id of the ami to use for the bastion host"
  type = string
}

variable "key_name" {
  description = "the name of the key pair to use for authentication"
  type = string
}

variable "public_subnet_id" {
  description = "the id of the public subnet to attach the bastion host to"
  type = list(string)
}
variable "bastion_sg_id" {
  description = "the id of the security group to attach to the bastion host"
  type = string
}