provider "aws" {
  region  = var.region
  version = "~> 3.0"
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "sg-november-tfstate-bucket"
    region  = "eu-west-2"
  }
}