# SSM Parameters for secrets
resource "aws_ssm_parameter" "rails_master_key" {
  name  = "/goosetunetv/rails_master_key"
  type  = "SecureString"
  value = var.rails_master_key

  tags = {
    Name = "goosetunetv-rails-master-key"
  }
}

resource "aws_ssm_parameter" "database_password" {
  name  = "/goosetunetv/database_password"
  type  = "SecureString"
  value = var.mysql_password

  tags = {
    Name = "goosetunetv-database-password"
  }
}
