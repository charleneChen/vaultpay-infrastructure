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

resource "aws_vpc_security_group_ingress_rule" "allow_app_private_a_traffic" {
  security_group_id = aws_security_group.rds_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = var.private_subnet_app_cidrs[0]
  from_port         = 5432
  to_port           = 5432
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_private_b_traffic" {
  security_group_id = aws_security_group.rds_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = var.private_subnet_app_cidrs[1]
  from_port         = 5432
  to_port           = 5432
}

resource "aws_db_instance" "vaultpay" {
  # RDS instance general settings
  identifier     = "vaultpay-postgres-instance"
  instance_class = "db.t4g.micro"
  engine         = "postgres"
  engine_version = "18"

  # Database settings
  db_name = var.db_name

  # Credentials
  username                    = var.db_username
  manage_master_user_password = true

  # Storage
  storage_type      = "gp3"
  allocated_storage = 20
  storage_encrypted = true

  # Network & Access
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.vaultpay.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Environment-aware settings
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot

  tags = {
    Name    = "${var.project_name}-postgres"
    Project = var.project_name
  }
}
