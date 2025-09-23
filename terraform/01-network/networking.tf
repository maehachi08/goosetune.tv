data "aws_availability_zones" "this" {
  state = "available"
}

locals {
  az_ids = data.aws_availability_zones.this.zone_ids

  # 10.0.0.0/16 を /24 に3つ切り出す
  subnet_cidrs = [
    cidrsubnet("10.0.0.0/16", 8, 1), # 10.0.1.0/24
    cidrsubnet("10.0.0.0/16", 8, 2), # 10.0.2.0/24
    cidrsubnet("10.0.0.0/16", 8, 3), # 10.0.3.0/24
  ]
}

# InternetGateway
resource "aws_internet_gateway" "goosetunetv-gw" {
  vpc_id = aws_vpc.goosetunetv.id

  tags = {
    Name = "goosetunetv"
  }
}

# Subnet
resource "aws_subnet" "goosetunetv" {
  count                = 3
  vpc_id               = aws_vpc.goosetunetv.id
  cidr_block           = local.subnet_cidrs[count.index]
  availability_zone_id = local.az_ids[count.index]        # Use not name but id
  tags = {
    Name = "goosetunetv-subnet-${local.az_ids[count.index]}"
  }
}

# RouteTable to the InternetGateway
resource "aws_route_table" "goosetunetv-route-table" {
  vpc_id = aws_vpc.goosetunetv.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.goosetunetv-gw.id}"
  }

  tags = {
    Name = "goosetunetv"
  }
}

resource "aws_route_table_association" "goosetunetv" {
  count          = 3
  subnet_id      = aws_subnet.goosetunetv[count.index].id
  route_table_id = aws_route_table.goosetunetv-route-table.id
}
