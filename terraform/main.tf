module "dpg_novmeber_elb" {
  source                   = "./modules/elastic_load_balancer"
  security_group_id        = aws_security_group.sg.security_group_id
  subnet_id                = aws_subnet.subnet1.subnet_id 
  UNIQUE_ANIMAL_IDENTIFIER = var.UNIQUE_ANIMAL_IDENTIFIER
}

module "dpg_november_asg" {
  source                   = "./modules/autoscaling_group"
  security_group_id        = aws_security_group.sg.security_group_id
  subnet_id                = aws_subnet.subnet1.subnet_id
  elb_id                   = module.dpg_novmeber_elb.elb_id
  UNIQUE_ANIMAL_IDENTIFIER = var.UNIQUE_ANIMAL_IDENTIFIER
}
resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

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
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }
}

resource "aws_route_table_association" "route-subnet1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table1.id
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