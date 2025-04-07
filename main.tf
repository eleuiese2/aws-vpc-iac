provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  count                = var.create ? 1 : 0
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count                   = var.create ? length(var.cidr_public_subnets) : 0
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = var.cidr_public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = var.create ? length(var.cidr_private_subnets) : 0
  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.cidr_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  count  = var.create ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}


resource "aws_eip" "nat_gateway_eip" {
  count  = var.create ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create ? 1 : 0
  allocation_id = aws_eip.nat_gateway_eip[0].id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_eip.nat_gateway_eip]
}


resource "aws_route_table" "public" {
  count  = var.create ? 1 : 0
  vpc_id = aws_vpc.main[0].id
}

resource "aws_route" "internet_route" {
  count                  = var.create ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway[0].id
  depends_on             = [aws_internet_gateway.internet_gateway]
}


resource "aws_route_table_association" "public_association" {
  count          = var.create ? length(var.cidr_public_subnets) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}


resource "aws_route_table" "private" {
  count  = var.create ? 1 : 0
  vpc_id = aws_vpc.main[0].id
}

resource "aws_route" "private_nat_route" {
  count                  = var.create ? 1 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[0].id
  depends_on             = [aws_nat_gateway.nat_gateway]
}


resource "aws_route_table_association" "private_association" {
  count          = var.create ? length(var.cidr_private_subnets) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}
