resource "aws_vpc" "goosetunetv" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "goosetunetv"
  }
}
