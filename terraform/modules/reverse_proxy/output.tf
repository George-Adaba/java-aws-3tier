output "reverse_proxy_private_ip" {
    description = "The private IP address of the Nginx instance"
    value       = aws_instance.nginx.private_ip
}

output "reverse_proxy_instance_id" {
    description = "The instance ID of the Nginx instance"
    value       = aws_instance.nginx.id
}