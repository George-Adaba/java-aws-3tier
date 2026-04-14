# i have created a resource block for the vpc 
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support   = true # this enables DNS support in the VPC, allowing instances to resolve domain names to IP addresses
  enable_dns_hostnames = true # this enables DNS hostnames in the VPC, allowing instances to have DNS hostnames that can be resolved to their private IP addresses

  tags = {
    Name = "${var.name}-vpc"
  }
}

# i have created a resource block for the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id # your internet gateway has to be assiciated with the vpc

  tags = {
    Name = "${var.name}-igw"
  }
}
# i have created a resource block for the public subnet
resource "aws_subnet" "public" {
    count             = 2 # create 2 public subnets
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.public_subnet_cidr[count.index] #cidrsubnet(var.cidr_block, 4, 0)
    availability_zone = var.azs[count.index]
    map_public_ip_on_launch = true # this assigns a public ip address to a lunched instance in the public subnet
# so basically the above resource block uses lists to assign cidr block and azs 
    tags = {
        Name = "${var.name}-public-subnet-${count.index + 1}"
    }
  
}

# i created a resource block for the route table and i added a public route to google through the internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id # this route directs all traffic destined for the internet   
  }

  tags = {
    Name = "${var.name}-public-rt"        
  }
}

# i created a resource block to assiociate the public subnets with the route table
resource "aws_route_table_association" "public" {
  count          = 2 # associate both public subnets with the route table
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# i created a resource block for the private suhbnet for the  app
resource "aws_subnet" "private-app" {
    count             = 2 # create 2 private subnets
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_app_subnet[count.index] # create private subnets with different predefined CIDR blocks
    availability_zone = var.azs[count.index]  # assign the private subne

    tags = {
        Name = "${var.name}-private-app-${count.index + 1}"
    }
}
# i created a resource block for the private subnets for the database  
resource "aws_subnet" "private-db" {
    count             = 2 # create 2 private subnets
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_db_subnet[count.index] # create private subnets with different predefined CIDR blocks
    availability_zone = var.azs[count.index]

    tags = {
        Name = "${var.name}-private-db-${count.index + 1}"
    }
}

resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        Name = "${var.name}-nat-eip"
    }
}
#for the nat gateway always use the first public subnet to place the nat gateway and assign the elastic ip to it and it depends on the 
#internet gateway to be created first because the nat gateway needs to be able to route traffic to the internet through the internet gateway
resource "aws_nat_gateway" "gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public[0].id 

    tags = {
        Name = "${var.name}-nat-gateway"
    }

    depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gateway.id # this directs all traffic thorugh the nat gateway 
    }

    tags = {
        Name = "${var.name}-private-rt"
    }
}

resource "aws_route_table_association" "private_app" {
    count        = 2
    subnet_id    = aws_subnet.private-app[count.index].id
    route_table_id = aws_route_table.private.id 
}

resource "aws_route_table_association" "private_db" {
    count        = 2
    subnet_id    = aws_subnet.private-db[count.index].id
    route_table_id = aws_route_table.private.id 
}