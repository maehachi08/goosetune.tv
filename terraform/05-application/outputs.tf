# Application Outputs
output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.goosetunetv.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.goosetunetv.zone_id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.goosetunetv.name
}