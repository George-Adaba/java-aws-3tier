# we need to give the external load balancer a url 

output "lb_dns_name" {
    description = "the DNS name of the load balancer"
    value       = aws_lb.app_lb.dns_name
}

output "internal_lb_dns_name" {
    description = "the DNS name of the internal load balancer"
    value       = aws_lb.internal_lb.dns_name
}