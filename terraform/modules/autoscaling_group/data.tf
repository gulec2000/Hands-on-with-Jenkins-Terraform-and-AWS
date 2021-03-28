data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]
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