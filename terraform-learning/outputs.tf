output "bucket_id" {
  description = "S3 bucket id"
  value       = module.s3_bucket.bucket_id
}
output "bucket_arn" {
  description = "Bucket ARN"
  value       = module.s3_bucket.bucket_arn
  sensitive   = true
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = module.s3_bucket.bucket_domain_name
}

output "bucket_region" {
  description = "which region the bucket was created in"
  value       = module.s3_bucket.bucket_region
}
