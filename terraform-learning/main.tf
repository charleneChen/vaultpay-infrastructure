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
  cidr_block           = "10.0.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "vaultpay-vpc"
    Project = "VaultPay"
  }

}
