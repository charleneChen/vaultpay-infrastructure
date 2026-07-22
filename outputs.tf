output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "app_private_subnet_ids" {
  description = "List of IDs of app private subnets"
  value       = module.vpc.app_private_subnet_ids
}

output "db_private_subnet_ids" {
  description = "List of IDs of db private subnets"
  value       = module.vpc.db_private_subnet_ids
}

output "ecr_repository_url" {
  description = "URL of the ECR repository holding the vaultpay container image"
  value       = aws_ecr_repository.vaultpay.repository_url
}

output "runtime_bucket_name" {
  description = "Name of the S3 bucket holding vaultpay runtime data"
  value       = module.s3_bucket.bucket_id
}
