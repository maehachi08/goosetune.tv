resource "aws_ecs_cluster" "goosetunetv" {
  name = "goosetunetv"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

