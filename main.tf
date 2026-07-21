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

resource "aws_db_subnet_group" "default" {
  name        = "main"
  description = "${var.project_name} DB subnet group"
  subnet_ids  = module.vpc.db_private_subnet_ids

  tags = {
    Name    = "${var.project_name} DB subnet group"
    Project = var.project_name
  }
}

resource "aws_security_group" "db_sg" {
  name        = "allow_app_db"
  description = "Allow inbound traffic from the app security group and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name    = "${var.project_name} DB security group"
    Project = var.project_name
  }
}
