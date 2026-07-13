variable "owner" {
  description = "Name of owner"
  type        = string
}

variable "tags" {
  description = "resource tags"
  type        = map(string)
}

variable "aws_profile" {
  description = "Name of AWS profile"
  type        = string
}