# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "goosetunetv-alb-sg"
  description = "Security group for GooseTune TV ALB"
  vpc_id      = aws_vpc.goosetunetv.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "goosetunetv-alb-sg"
  }
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "goosetunetv-ecs-tasks-sg"
  description = "Security group for GooseTune TV ECS tasks"
  vpc_id      = aws_vpc.goosetunetv.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "goosetunetv-ecs-tasks-sg"
  }
}