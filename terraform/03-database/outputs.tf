# Database Outputs
output "database_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.default.endpoint
}

output "database_address" {
  description = "RDS instance address"
  value       = aws_db_instance.default.address
}

output "database_port" {
  description = "RDS instance port"
  value       = aws_db_instance.default.port
}