# Network Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.goosetunetv.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.goosetunetv[0].id, aws_subnet.goosetunetv[1].id, aws_subnet.goosetunetv[2].id]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.goosetunetv-gw.id
}

output "ecs_tasks_security_group_id" {
  description = "ID of the ECS tasks security group"
  value       = aws_security_group.ecs_tasks.id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}