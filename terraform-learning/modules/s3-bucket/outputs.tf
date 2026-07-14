output "bucket_id" {
  description = "S3 bucket id"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_region" {
  description = "AWS region that S3 bucket was created in"
  value       = aws_s3_bucket.this.region
}
