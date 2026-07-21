output "db_endppint" {
  description = "Database endpoint"
  value       = aws_db_instance.vaultpay.endpoint
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.vaultpay.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.vaultpay.db_name
}

output "db_security_group_id" {
  description = "Database security group ID"
  value       = aws_db_instance.vaultpay.security_group_id
}

output "db_master_secret_arn" {
  description = "Database master secret ARN"
  value       = aws_db_instance.vaultpay.master_secret_arn
}
