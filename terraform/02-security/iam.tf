# IAM Role for ECS Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "goosetunetv-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "goosetunetv-ecs-execution-role"
  }
}

# IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name = "goosetunetv-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "goosetunetv-ecs-task-role"
  }
}

# IAM Policy Attachment for ECS Execution Role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Policy for SSM Parameters Access
resource "aws_iam_role_policy" "ecs_execution_ssm_policy" {
  name = "goosetunetv-ecs-execution-ssm-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ]
        Resource = [
          aws_ssm_parameter.rails_master_key.arn,
          aws_ssm_parameter.database_password.arn
        ]
      }
    ]
  })
}
