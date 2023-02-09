data "aws_availability_zones" "available" {}

# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_prefix}.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Name        = "${var.namespace}-main_vpc"
    Environment = "${var.environment}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.namespace}-igw"
    Environment = "${var.environment}"
  }
}

# Subnets
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  cidr_block = lookup(
    var.public_subnets,
    element(
      var.availability_zones,
      count.index
    )
  )
  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    Name        = "${var.namespace}-${format("public_subnet-%03d", count.index)}"
    Environment = "${var.environment}"
  }
}

# Route table for internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.namespace}-public"
    Environment = var.environment
  }
}

resource "aws_route" "to_public_internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  # goes to IGW
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_route_table_assoc" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}