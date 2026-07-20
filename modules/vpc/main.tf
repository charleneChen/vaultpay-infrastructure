resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name    = "${var.project_name}-public-subnet-a"
    Project = var.project_name
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.azs[1]

  tags = {
    Name    = "${var.project_name}-public-subnet-b"
    Project = var.project_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "${var.project_name}-public-rt"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "public_a_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "public_b_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_b.id
}

resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_app_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name    = "${var.project_name}-private-app-subnet-a"
    Project = var.project_name
  }
}

resource "aws_subnet" "private_app_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_app_cidrs[1]
  availability_zone = var.azs[1]

  tags = {
    Name    = "${var.project_name}-private-app-subnet-b"
    Project = var.project_name
  }
}

resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_db_cidrs[0]
  availability_zone = var.azs[0]

  tags = {
    Name    = "${var.project_name}-private-db-subnet-a"
    Project = var.project_name
  }
}

resource "aws_subnet" "private_db_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_db_cidrs[1]
  availability_zone = var.azs[1]

  tags = {
    Name    = "${var.project_name}-private-db-subnet-b"
    Project = var.project_name
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name    = "${var.project_name}-eip"
    Project = var.project_name
  }
}

resource "aws_nat_gateway" "nat-gw" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id

  tags = {
    Name    = "${var.project_name}-nat-gw"
    Project = var.project_name
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name    = "${var.project_name}-private-rt"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "private_app_a_association" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_app_a.id
}

resource "aws_route_table_association" "private_app_b_association" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_app_b.id
}
