variable "name" {
    description = "the name of the project"
    type = string
}

variable "ami_id" {
    description = "the id of the ami"
    type = string
}

variable "private_app_subnet_id" {
    description = "the id of the private app subnet"
    type = list(string)
}

variable "tomcat_sg_id" {
    description = "the id of the tomcat security group"
    type = string
}

variable "key_name" {
    description = "the name of the key pair to use for authentication"
    type = string
}