# resource block for the load balancer


resource "aws_lb" "app_lb" {
    name = "${var.name}-app-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.lb_sg_id]
    subnets = var.public_subnet_ids

    tags = {
        Name = "${var.name}-app-lb"
    }
}

# we also have to create a resource block for the target group

resource "aws_lb_target_group" "app_tg" {
    name = "${var.name}-app-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        path = "/" # best practice is to have a health check endpoint in your application that returns 200 if the app is healthy and 500 if it's not healthy
}
}

# we also have to create a resource block for the listener

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# we also have to create a resource block for the target group attachment

resource "aws_lb_target_group_attachment" "app_tg_attachment" {
    target_group_arn = aws_lb_target_group.app_tg.arn
    target_id = var.reverse_proxy_instance_id
    port = 80
}

# we have to create a resource block for the internal load balancer between nginx and tomcat

resource "aws_lb" "internal_lb" {
    name = "${var.name}-internal-lb"
    internal = true
    load_balancer_type = "application"
    security_groups = [var.internal_lb_sg_id]
    subnets = var.private_app_subnet_ids

    tags = {
        Name = "${var.name}-internal-lb"
    }
}

# internal load balancer target group for tomcat
resource "aws_lb_target_group" "internal_tg" {
    name = "${var.name}-internal-tg"
    port = 8080
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "instance"

    health_check {
        enabled = true
        healthy_threshold = 3
        interval = 30
        matcher = "200"
        path = "/"
        port = "traffic-port"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 3
    }
}

# internal load balancer listener
resource "aws_lb_listener" "internal_listener" {
    load_balancer_arn = aws_lb.internal_lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.internal_tg.arn
    }
}

# internal load balancer target group attachment - attach tomcat to internal ALB
resource "aws_lb_target_group_attachment" "internal_tg_attachment" {
    target_group_arn = aws_lb_target_group.internal_tg.arn
    target_id = var.tomcat_instance_id
    port = 8080
}