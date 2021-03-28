# Create the ELB
resource "aws_elb" "elb" {
  name            = "playground-${var.UNIQUE_ANIMAL_IDENTIFIER}"
  security_groups = data.aws_security_group.sg.id
  subnets         = data.aws_subnet.subnet1.id

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:80"
    interval            = 30
  }

  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "playground-${var.UNIQUE_ANIMAL_IDENTIFIER}"
  }
}

data "aws_security_group" "sg" {
  vpc_id = data.aws_vpc.vpc1.id
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