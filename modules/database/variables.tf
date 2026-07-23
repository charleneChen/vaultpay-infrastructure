variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "app_security_group_id" {
  description = "The ID of the app security group"
  type        = string
}

variable "db_private_subnet_ids" {
  description = "The private subnets IDs for the RDS subnet group"
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
