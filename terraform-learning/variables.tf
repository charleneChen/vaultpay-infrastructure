variable "owner" {
  description = "Name of owner"
  type        = string
}

variable "project_name" {
  description = "Name of project"
  type        = string
}

variable "tags" {
  description = "resource tags"
  type        = map(string)
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

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}
