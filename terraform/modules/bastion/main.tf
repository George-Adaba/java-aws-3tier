
# a bastion host is a special purpose server that acts as a gateway between a trusted network and an untrusted network. 
#It is used to securely access resources in a private network from an external network, such as the internet. 
#The bastion host is typically placed in a DMZ (demilitarized zone) and is configured with strict security measures to prevent unauthorized access.

resource "aws_instance" "bastion" {
    ami           = var.ami_id
    instance_type = "t3.micro"

# attach it to the public subnet and security group
    subnet_id               = var.public_subnet_id[0]# attach it to the first public subnet 
    vpc_security_group_ids  = [var.bastion_sg_id]# attach it to the bastion security group
  
# because we are sshing into the bastion host we need to assign it a public ip
    associate_public_ip_address = true

# when you create a bastion host you need to specify the name of the .pem file for authentication

    key_name = var.key_name

    tags = {
        Name = "${var.name}-bastion-host"
}
}