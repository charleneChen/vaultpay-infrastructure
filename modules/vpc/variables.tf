variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
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
