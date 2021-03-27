variable "security_group_id" {
  default = aws_security_group.sg.security_group_id
}

variable "subnet_id" {
  default = "subnet-874c29fd"
}

variable "vpc_id" {
  default = "vpc-7265321a"
}

variable "region" {
  default = "eu-west-2"
}

variable "UNIQUE_ANIMAL_IDENTIFIER" {
  default = "spider"
}