resource "aws_db_subnet_group" "vaultpay" {
  name        = "vaultpay-rds-subnet-group"
  description = "Subnets available for ${var.project_name} RDS database placement"
  subnet_ids  = module.vpc.db_private_subnet_ids

  tags = {
    Name    = "${var.project_name}-rds-subnet-group"
    Project = var.project_name
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "vaultpay-rds-sg"
  description = "Allow inbound traffic from the app security group and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name    = "${var.project_name}-rds-sg"
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
