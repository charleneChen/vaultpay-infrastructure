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
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = "us-east-1a"

  tags = {
    Name    = "vaultpay-public-subnet-a"
    Project = var.project_name
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = "us-east-1b"

  tags = {
    Name    = "vaultpay-public-subnet-b"
    Project = var.project_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "vaultpay-igw"
    Project = var.project_name
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "vaultpay-public-rt"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "public-a-association" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public-a.id
}

resource "aws_route_table_association" "public-b-association" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public-b.id
}

resource "aws_subnet" "private-app-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-app-cidrs[0]
  availability_zone = "us-east-1a"

  tags = {
    Name    = "vaultpay-private-app-subnet-a"
    Project = var.project_name
  }
}

resource "aws_subnet" "private-app-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-app-cidrs[1]
  availability_zone = "us-east-1b"

  tags = {
    Name    = "vaultpay-private-app-subnet-b"
    Project = var.project_name
  }
}

resource "aws_subnet" "private-db-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-db-cidrs[0]
  availability_zone = "us-east-1a"

  tags = {
    Name    = "vaultpay-private-db-subnet-a"
    Project = var.project_name
  }
}

resource "aws_subnet" "private-db-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private-subnet-db-cidrs[1]
  availability_zone = "us-east-1b"

  tags = {
    Name    = "vaultpay-private-db-subnet-b"
    Project = var.project_name
  }
}
