provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile
}

# module "s3_bucket" {
#   source      = "./modules/s3-bucket"
#   bucket_name = "${var.owner}-tf-learning-bucket"
#   environment = var.environment
#   tags        = var.tags
# }

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
