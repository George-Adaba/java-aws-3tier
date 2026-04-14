# resource block for the tomcat server

resource "aws_instance" "app-server" {
    ami             = var.ami_id
    instance_type   = "t3.micro"

    key_name = var.key_name
    # attach it to the private subnet and security group
    subnet_id              = var.private_app_subnet_id[0]# attach it to the first private subnet 
    vpc_security_group_ids = [var.tomcat_sg_id]# attach it to the tomcat security group

    user_data = file("${path.root}/scripts/install_tomcat.sh") # use the user data script to install and configure tomcat

    associate_public_ip_address = false # we set it to false because we don't want to expose our app server to the internet

    tags = {
        Name = "${var.name}-app-server"
    }
}

