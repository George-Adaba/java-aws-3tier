module "network" {
  source = "./modules/vpc"

  name               = var.name
  cidr_block         = var.cidr_block
  public_subnet_cidr   = var.public_subnet_cidr
  private_app_subnet   = var.private_app_subnet
  private_db_subnet    = var.private_db_subnet
  azs                = var.azs
}

module "security_groups" {
  source = "./modules/security_groups"
  name = var.name
  vpc_id = module.network.vpc_id
  vpc_cidr = var.cidr_block
}

module "bastion" {
  source = "./modules/bastion"
  name             = var.name
  ami_id           = "ami-02dfbd4ff395f2a1b"
  public_subnet_id = module.network.public_subnet_id
  bastion_sg_id    = module.security_groups.bastion_sg_id
  key_name         = var.key_name
  
}

module "rds" {
  source = "./modules/rds"
  name = var.name
  private_db_subnet_id = module.network.private_db_subnet_id
  rds_sg_id = module.security_groups.rds_sg_id
}

module "app" {
  source = "./modules/app"
  name = var.name
  ami_id = "ami-02dfbd4ff395f2a1b"
  private_app_subnet_id = module.network.private_app_subnet_id
  tomcat_sg_id = module.security_groups.tomcat_sg_id
  key_name = var.key_name
}

module "reverse_proxy" {
  source = "./modules/reverse_proxy"
  name = var.name
  ami_id = "ami-02dfbd4ff395f2a1b"
  private_app_subnet_id = module.network.private_app_subnet_id
  nginx_sg_id = module.security_groups.nginx_sg_id
  key_name = var.key_name
  tomcat_private_ip = module.app.tomcat_private_ip
  internal_lb_dns_name = module.load_balancer.internal_lb_dns_name
}

module "load_balancer" {
  source = "./modules/load_balancer"
  name = var.name
  lb_sg_id = module.security_groups.lb_sg_id
  public_subnet_ids = module.network.public_subnet_id
  vpc_id = module.network.vpc_id
  reverse_proxy_private_ip = module.reverse_proxy.reverse_proxy_private_ip
  reverse_proxy_instance_id = module.reverse_proxy.reverse_proxy_instance_id
  internal_lb_sg_id = module.security_groups.internal_lb_sg_id
  private_app_subnet_ids = module.network.private_app_subnet_id
  tomcat_instance_id = module.app.tomcat_instance_id
}