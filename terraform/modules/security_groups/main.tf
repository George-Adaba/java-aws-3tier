# this is  the security group configurations for nginx, tomcat and rds instances

# security group for nginx instances
resource "aws_security_group" "nginx_sg" {
    name    = "${var.name}-nginx-sg" # this is the unique name for the firewall security group
    vpc_id  = var.vpc_id

 #so basically ingress are like inbound rules for the security groups 
    ingress {
        from_port   = 80 # allow from port 80
        to_port     = 80 # allow to port 80 thereby securing http connection
        protocol    = "tcp" # allow tcp protocol 
        cidr_blocks = [var.vpc_cidr] # allow traffic from within the vpc only for security purposes
    }

 # allow ssh from bastion host for testing purposes
    ingress {
        description = "allow ssh from bastion host for testing purposes"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.bastion_sg.id] # allow from only bastion host for testing purposes 
    }

 # so basically egress are like outbound rules for the security groups
    egress {
        from_port   = 0 # allow from any port
        to_port     = 0 # allow to any port
        protocol    = "-1" # allow all protocols
        cidr_blocks = ["0.0.0.0/0"] # allow traffic from any ip address
    }

    tags = {
        Name = "${var.name}-nginx-sg"
    }
}

# security group for tomcat instances
resource "aws_security_group" "tomcat_sg" {
    name    = "${var.name}-tomcat-sg" # this is the unique name for our tomcat security group
    vpc_id =  var.vpc_id

 #so basically ingress are like inbound rules for the security groups 
    ingress {
        from_port = 8080 # allow from port 8080
        to_port   = 8080 # allow to port 8080 thereby securing tomcat application connection
        protocol  = "tcp" # allow tcp protocol
        security_groups = [aws_security_group.nginx_sg.id] # allows traffic from only nginx security group
    }

    # 2. NEW: Allow SSH (Port 22) from Bastion only
    # This fixes your "Connection timed out" during the jump
    ingress {
        description     = "Allow SSH from Bastion"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }

    # 3. NEW: Allow Testing (Port 8080) from Bastion only
    # This fixes your "curl" failure
    ingress {
        description     = "Allow testing from Bastion"
        from_port       = 8080
        to_port         = 8080
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }

    # Allow traffic from internal load balancer on port 8080
    ingress {
        description     = "Allow traffic from internal load balancer"
        from_port       = 8080
        to_port         = 8080
        protocol        = "tcp"
        security_groups = [aws_security_group.internal_lb_sg.id]
    }
    
    egress {
        from_port = 0 # any port
        to_port   = 0 # any port
        protocol  = "-1" # all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-tomcat-sg"
    }

}

# security group for RDS instances
resource "aws_security_group" "rds_sg" {
    name    = "${var.name}-rds-sg"
    vpc_id  = var.vpc_id

 #so basically ingress are like inbound rules for the security groups 
    ingress {
        from_port   = 3306 # allow from port 3306
        to_port     = 3306 # allow to port 3306 thereby securing mysql connection
        protocol    = "tcp"
        security_groups = [aws_security_group.tomcat_sg.id] # allow from only tomcat backend server
    }

# FOR TESTING
    ingress {
        description = "allow access to rds from bastion host for testing purposes"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.bastion_sg.id] # allow from only bastion host for testing purposes 
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-rds-sg"
    }
}

# security host for bastion host

resource "aws_security_group" "bastion_sg" {
    name        = "${var.name}-bastion-sg"
    description = "allow access to bastion host from anywhere"
    vpc_id      = var.vpc_id 

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # for learning we use 0.0.0.0/0 but in production always restrict it to your ip address
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "${var.name}-bastion-sg"
    }
}

#security group for load balancer
resource "aws_security_group" "lb_sg" {
  name        = "${var.name}-lb-sg"
  description = "security group for load balancer"
  vpc_id      = var.vpc_id 

  # ingress rule
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-lb-sg"
  }
}

#create security group for the private load balancer between nginx and tomcat

resource "aws_security_group" "internal_lb_sg" {
    name        = "${var.name}-internal-lb-sg"
    description = "security group for internal load balancer"
    vpc_id      = var.vpc_id 

    # ingress rule
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.nginx_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-internal-lb-sg"
    }
}

