# this are variables that are going to be exported from the vpc module and used else where in the project

output "vpc_id" {
    description = "The ID of the VPC created by this module."
    value       = aws_vpc.main.id
}

output "public_subnet_id" {
    description = "The ID of the public subnet created by this module"
    value       = aws_subnet.public[*].id
}

output "private_app_subnet_id" {
    description = "The ID of the private app subnet created by this module"
    value       = aws_subnet.private-app[*].id
}

output "private_db_subnet_id" {
    description = "The ID of the private db subnet created by this module"
    value       = aws_subnet.private-db[*].id
}
