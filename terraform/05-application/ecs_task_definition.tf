# ECS Task Definition
resource "aws_ecs_task_definition" "goosetunetv" {
  family                   = "goosetunetv"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.terraform_remote_state.security.outputs.ecs_execution_role_arn
  task_role_arn           = data.terraform_remote_state.security.outputs.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name  = "goosetunetv"
      image = var.ecr_image_uri
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DATABASE_HOST"
          value = data.terraform_remote_state.database.outputs.database_address
        },
        {
          name  = "DATABASE_PORT"
          value = "3306"
        },
        {
          name  = "RAILS_ENV"
          value = "development"
        }
      ]
      secrets = [
        {
          name      = "RAILS_MASTER_KEY"
          valueFrom = data.terraform_remote_state.security.outputs.rails_master_key_arn
        },
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = data.terraform_remote_state.security.outputs.database_password_arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.goosetunetv.name
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      essential = true
    }
  ])

  tags = {
    Name = "goosetunetv"
  }
}
