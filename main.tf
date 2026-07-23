provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile
}

module "vpc" {
  source                   = "./modules/vpc"
  project_name             = var.project_name
  vpc_cidr                 = var.vpc_cidr
  azs                      = var.azs
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_subnet_app_cidrs = var.private_subnet_app_cidrs
  private_subnet_db_cidrs  = var.private_subnet_db_cidrs
}

module "database" {
  source                   = "./modules/database"
  project_name             = var.project_name
  vpc_id                   = module.vpc.vpc_id
  private_subnet_app_cidrs = var.private_subnet_app_cidrs
  db_private_subnet_ids    = module.vpc.db_private_subnet_ids
  db_name                  = var.db_name
  db_username              = var.db_username
  multi_az                 = var.multi_az
  backup_retention_period  = var.backup_retention_period
  deletion_protection      = var.deletion_protection
  skip_final_snapshot      = var.skip_final_snapshot
}

resource "aws_ecr_repository" "vaultpay" {
  name = var.project_name

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = var.ecr_force_delete

  tags = {
    Name        = "${var.project_name}-ecr-registry"
    Project     = var.project_name
    Environment = var.environment
  }
}

module "s3_bucket" {
  source        = "./modules/s3-bucket"
  bucket_name   = "${data.aws_caller_identity.current.account_id}-${var.project_name}-reports"
  force_destroy = var.s3_force_destroy

  tags = {
    Name        = "${var.project_name}-s3-reports"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role" "app" {
  name = "${var.project_name}-app-role"

  assume_role_policy = data.aws_iam_policy_document.instance_assume_role.json

  tags = {
    Name        = "${var.project_name}-app-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Attach multiple AWS managed policies
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = data.aws_iam_policy.managed_policy

  role       = aws_iam_role.app.name
  policy_arn = each.value.arn
}

# Add an inline policy
resource "aws_iam_role_policy" "inline" {
  name   = "${var.project_name}-app-inline-policy"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.inline_policy.json
}

resource "aws_iam_instance_profile" "app_role_profile" {
  name = "${var.project_name}-app-role-profile"
  role = aws_iam_role.app.name

  tags = {
    Name        = "${var.project_name}-app-role-profile"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP and HTTPS inbound traffic from anywhere"

  vpc_id = module.vpc.vpc_id

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_http" {
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "TCP"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_allow_all" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_lb" "app" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnet_ids

  tags = {
    Name        = "${var.project_name}-alb"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.project_name}-alb-target-group"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name        = "${var.project_name}-alb-listener"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for the app"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "${var.project_name}-app-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "app" {
  security_group_id            = aws_security_group.app.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "app" {
  security_group_id = aws_security_group.app.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = data.aws_ssm_parameter.amazon_linux_2023_arm64.value
  instance_type = "t4g.small"

  iam_instance_profile {
    arn = aws_iam_instance_profile.app_role_profile.arn
  }

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      aws_region           = data.aws_region.current.region
      ecr_registry         = split("/", aws_ecr_repository.vaultpay.repository_url)[0]
      ecr_repository_url   = aws_ecr_repository.vaultpay.repository_url
      image_tag            = var.image_tag
      db_master_secret_arn = module.database.db_master_secret_arn
      db_host              = split(":", module.database.db_endpoint)[0]
      db_name              = module.database.db_name
      db_port              = module.database.db_port
      artifact_bucket_name = module.s3_bucket.bucket_id
    })
  )

  tags = {
    Name        = "${var.project_name}-app-lt"
    Project     = var.project_name
    Environment = var.environment
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-app"
      Project     = var.project_name
      Environment = var.environment
    }
  }
}
