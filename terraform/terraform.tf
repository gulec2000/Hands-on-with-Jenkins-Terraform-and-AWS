provider "aws" {
  region  = var.region
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "sg-november-tfstate-bucket"
    region  = "eu-west-2"
  }
}