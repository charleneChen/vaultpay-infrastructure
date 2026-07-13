provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile
}

resource "aws_s3_bucket" "example" {
  bucket = "${var.owner}-tf-learning-bucket"

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}