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
