resource "aws_db_subnet_group" "goosetunetv" {
  name       = "goosetunetv-db-subnet-group"
  subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids

  tags = {
    Name = "goosetunetv DB subnet group"
  }
}

resource "aws_security_group" "rds" {
  name        = "goosetunetv-rds-sg"
  description = "Security group for GooseTune TV RDS"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.network.outputs.ecs_tasks_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "goosetunetv-rds-sg"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "goosetunetv_development"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.mysql_username
  password               = var.mysql_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.goosetunetv.name

  tags = {
    Name = "goosetunetv-mysql"
  }
}

