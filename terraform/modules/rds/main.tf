# this is the module for the RDS database instance it will create the database

# attach the database to the private subnets and security group created in the vpc and security group modules
resource "aws_db_subnet_group" "db_subnet_group" {
    name       = "${var.name}-db-subnet-group"
    subnet_ids = var.private_db_subnet_id

    tags = {
        Name = "${var.name}-db-subnet-group"
    }
  
}

resource "aws_db_instance" "database" {
    allocated_storage   = 20  #maximum for free tier
    storage_type        = "gp2"
    engine              = "mysql"
    engine_version      =  "8.0"
    instance_class      = "db.t3.micro"
    db_name             = "app_db"# note aws does not allow hyphens in database name
    username            = "admin"
    password            = "admin123" # in production please use secrets manager or ssm parameter store to store your database creds
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name # we attach the database instance to the subnet group we created earlier
    vpc_security_group_ids = [var.rds_sg_id] # we attach the database instance to the rds security group we created earlier
    multi_az = false # for learning we set it to false but in production always set it to true for high availability
    skip_final_snapshot = true # for learning we set it to true but in production always set it to false to take a final backup of the database befor deleting 
    publicly_accessible = false # we set it to false because we don't want to expose our database to the internet

}