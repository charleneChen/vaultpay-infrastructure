provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile
}

module "s3_bucket" {
  source      = "./modules/s3-bucket"
  bucket_name = "${var.owner}-tf-learning-bucket"
  environment = var.environment
  tags        = var.tags
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "vaultpay-vpc"
    Project = var.project_name
  }
}

resource "aws_subnet" "public-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[0]
  availability_zone = "us-east-1a"

  tags = {
    Name    = "vaultpay-public-subnet-a"
    Project = var.project_name
  }
}

resource "aws_subnet" "public-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[1]
  availability_zone = "us-east-1b"

  tags = {
    Name    = "vaultpay-public-subnet-b"
    Project = var.project_name
  }
}
