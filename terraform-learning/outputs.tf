output "bucket_arn" {
  description = "bucket ARN"
  value       = aws_s3_bucket.example.arn
  sensitive   = true
}

output "bucket_url" {
  description = "bucket domain name"
  value       = aws_s3_bucket.example.bucket_domain_name
}

output "bucket_region" {
  description = "which region the bucket was created in"
  value       = aws_s3_bucket.example.bucket_region
}