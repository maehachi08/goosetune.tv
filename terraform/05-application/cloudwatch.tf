# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "goosetunetv" {
  name              = "/ecs/goosetunetv"
  retention_in_days = 30

  tags = {
    Name = "goosetunetv"
  }
}
