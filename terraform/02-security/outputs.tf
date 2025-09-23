# Security Outputs
output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate_validation.goosetune_tv.certificate_arn
}

output "ecs_execution_role_arn" {
  description = "ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "rails_master_key_arn" {
  description = "ARN of the Rails master key in SSM"
  value       = aws_ssm_parameter.rails_master_key.arn
}

output "database_password_arn" {
  description = "ARN of the database password in SSM"
  value       = aws_ssm_parameter.database_password.arn
}

output "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = data.aws_route53_zone.goosetune_tv.zone_id
}