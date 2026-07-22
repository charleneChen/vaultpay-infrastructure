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
