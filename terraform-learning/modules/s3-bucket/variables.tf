variable "bucket_name" {
  description = "Name of S3 bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, test, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Tags for S3 bucket"
  type        = map(string)
}
