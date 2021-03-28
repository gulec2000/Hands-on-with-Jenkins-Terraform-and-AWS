module "dpg_novmeber_elb" {
  source                   = "./modules/elastic_load_balancer" 
  UNIQUE_ANIMAL_IDENTIFIER = var.UNIQUE_ANIMAL_IDENTIFIER
}

module "dpg_november_asg" {
  source                   = "./modules/autoscaling_group"
  subnet_id                = data.aws_subnet.subnet1.id
  security_group_id        = data.aws_security_group.sg.id
  elb_id                   = module.dpg_novmeber_elb.elb_id
  UNIQUE_ANIMAL_IDENTIFIER = var.UNIQUE_ANIMAL_IDENTIFIER
}

resource "aws_security_group" "sg" {
  name        = "sg"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "subnet1" {
  availability_zone       = "eu-west-2a"
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = "true"

}

# INTERNET_GATEWAY
resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.vpc1.id
}

# ROUTE_TABLE
resource "aws_route_table" "route_table1" {
  vpc_id = data.aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }
}

resource "aws_route_table_association" "route-subnet1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table1.id
}

data "aws_security_group" "sg" {
  tags = {
    "Purpose" = "Playground"
  }
}
data "aws_subnet" "subnet1" {
  vpc_id = data.aws_vpc.vpc1.id
  tags = {
    Purpose = "Playground"
    count = 0
  }
}
data "aws_vpc" "vpc1" {
  tags = {
    Purpose = "Playground"
  }
}