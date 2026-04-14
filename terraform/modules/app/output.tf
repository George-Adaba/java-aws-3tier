output "tomcat_private_ip" {
    description = "The private IP address of the Tomcat instance"
    value       = aws_instance.app-server.private_ip
}

output "tomcat_instance_id" {
    description = "The instance ID of the Tomcat instance"
    value       = aws_instance.app-server.id
}