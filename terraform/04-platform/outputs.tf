# Platform Outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.goosetunetv.repository_url
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.goosetunetv.id
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.goosetunetv.arn
}