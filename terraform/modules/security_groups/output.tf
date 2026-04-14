output "bastion_sg_id" {
  description = "The ID of the Bastion Security Group"
  # Must match the resource name 'bastion_sg' exactly
  value       = aws_security_group.bastion_sg.id 
}

output "rds_sg_id" {
  description = "The ID of the RDS Security Group"
  value       = aws_security_group.rds_sg.id
}

output "tomcat_sg_id" {
  description = "The ID of the Tomcat Security Group"
  value       = aws_security_group.tomcat_sg.id
  
}

output "nginx_sg_id" {
  description = "The ID of the Nginx Security Group"
  value       = aws_security_group.nginx_sg.id
}

output "lb_sg_id" {
  description = "the ID of the load balancer"
  value       = aws_security_group.lb_sg.id
}

output "internal_lb_sg_id" {
    description = "the ID of the internal load balancer security group"
    value       = aws_security_group.internal_lb_sg.id
}