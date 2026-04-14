# module for nginx as a reverse proxy server

resource "aws_instance" "nginx" {
    ami             = var.ami_id
    instance_type   = "t3.micro"

    key_name = var.key_name

    subnet_id = var.private_app_subnet_id[0]# attach it to the first private subnet
    vpc_security_group_ids = [var.nginx_sg_id]# attach it to

    user_data = templatefile("${path.root}/scripts/configure_nginx.sh", {
        internal_lb_dns_name = var.internal_lb_dns_name
    }) # use the user data script to install and configure nginx

    associate_public_ip_address = false

    tags = {
      Name = "${var.name}-nginx server"
    }
}