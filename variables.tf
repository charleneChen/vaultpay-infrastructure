variable "project_name" {
  description = "Name of project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_profile" {
  description = "Name of AWS profile"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones for the VPC"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_app_cidrs" {
  description = "CIDR blocks for private app subnets"
  type        = list(string)
}

variable "private_subnet_db_cidrs" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
}

variable "db_name" {
  description = "The name of database"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "multi_az" {
  description = "Whether to deploy the RDS instance across multiple availability zones"
  type        = bool
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled on the RDS instance"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when the instance is destroyed"
  type        = bool
}

variable "s3_force_destroy" {
  description = "Whether to force destroy the S3 bucket when it is destroyed"
  type        = bool
  default     = false
}

variable "ecr_force_delete" {
  description = "Whether to force delete the ECR registry when it is destroyed"
  type        = bool
  default     = false
}

variable "image_tag" {
  description = "Container image tag to deploy"
  type        = string
  default     = "latest"
}
