variable "name" {
    description = "the name of the project"
    type        = string
}

variable "ami_id" {
    description = "the AMI ID for the nginx server"
    type        = string
}

variable "private_app_subnet_id" {
    description = "the list of private app subnet IDs"
    type        = list(string)
}

variable "nginx_sg_id" {
    description = "the security group ID for the nginx server"
    type        = string
}

variable "key_name" {
    description = "the key pair name for the nginx server"
    type        = string
}

variable "tomcat_private_ip" {
    description = "the private IP of the tomcat server (deprecated - use internal_lb_dns_name instead)"
    type        = string
}

variable "internal_lb_dns_name" {
    description = "the DNS name of the internal load balancer"
    type        = string
}
