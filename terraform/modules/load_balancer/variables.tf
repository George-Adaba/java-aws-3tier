# variable definition for load balancer module

variable "name" {
    description = "the name of the project"
    type        = string
}

variable "lb_sg_id" {
    description = "the ID for the load balancer security group"
    type = string
}

variable "public_subnet_ids" {
    description = "the ID for the public subnet"
    type = list(string)
}

variable "vpc_id" {
    description = "the ID for the VPC"
    type = string
}

variable "reverse_proxy_private_ip" {
  description = "the private IP address of the reverse proxy (nginx) instance"
  type        = string
}

variable "reverse_proxy_instance_id" {
    description = "the instance ID of the reverse proxy (nginx) instance"
    type        = string
}

variable "internal_lb_sg_id" {
     description = "the ID of the internal load balancer security group"
     type        = string
}

variable "private_app_subnet_ids" {
    description = "the list of private app subnet IDs for the internal load balancer"
    type        = list(string)
}

variable "tomcat_instance_id" {
    description = "the instance ID of the tomcat app server"
    type        = string
}