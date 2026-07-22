variable "bucket_name" {
  description = "Name of S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Force destroy S3 bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for S3 bucket"
  type        = map(string)
}
