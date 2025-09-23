# ECS Service
resource "aws_ecs_service" "goosetunetv" {
  name            = "goosetunetv"
  cluster         = data.terraform_remote_state.platform.outputs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.goosetunetv.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.terraform_remote_state.network.outputs.public_subnet_ids
    security_groups  = [data.terraform_remote_state.network.outputs.ecs_tasks_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.goosetunetv.arn
    container_name   = "goosetunetv"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.goosetunetv
  ]

  tags = {
    Name = "goosetunetv"
  }
}
