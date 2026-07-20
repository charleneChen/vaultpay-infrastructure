output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "app_private_subnet_ids" {
  description = "List of IDs of app private subnets"
  value = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id
  ]
}

output "db_private_subnet_ids" {
  description = "List of IDs of database private subnets"
  value = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]
}
