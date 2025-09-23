resource "aws_ecr_repository" "goosetunetv" {
  name                 = "goosetunetv"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "goosetunetv"
  }
}

resource "aws_ecr_lifecycle_policy" "goosetunetv" {
  repository = aws_ecr_repository.goosetunetv.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
