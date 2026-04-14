
variable "name" {
  description = "name of the project"
  type = string
}

variable "private_db_subnet_id" {
  description = "list of private subnet IDs for the RDS database"
  type = list(string)
}

variable "rds_sg_id" {
  description = "The id of the rds security group"
  type = string
}