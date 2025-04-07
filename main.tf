resource "aws_vpc" "main" {
  count                = var.create ? 1 : 0
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

# Crear subredes públicas
resource "aws_subnet" "public" {
  for_each                = var.create ? toset(var.cidr_public_subnets) : {}
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = each.value
  availability_zone       = element(var.availability_zones, index(var.cidr_public_subnets, each.key)) # Usamos las zonas de disponibilidad de la variable
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${each.key}"
  }
}

# Crear subredes privadas
resource "aws_subnet" "private" {
  for_each          = var.create ? toset(var.cidr_private_subnets) : {}
  vpc_id            = aws_vpc.main[0].id
  cidr_block        = each.value
  availability_zone = element(var.availability_zones, index(var.cidr_private_subnets, each.key)) # Usamos las zonas de disponibilidad de la variable
  tags = {
    Name = "private-subnet-${each.key}"
  }
}

# Crear Internet Gateway (para subredes públicas)
resource "aws_internet_gateway" "internet_gateway" {
  count  = var.create ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}

# Crear NAT Gateway para subredes privadas
resource "aws_eip" "nat_gateway_eip" {
  count = var.create ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create ? 1 : 0
  allocation_id = aws_eip.nat_gateway_eip[0].id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_eip.nat_gateway_eip]
}

# Tabla de enrutamiento para subredes públicas
resource "aws_route_table" "public" {
  count  = var.create ? 1 : 0
  vpc_id = aws_vpc.main[0].id
}

resource "aws_route" "internet_route" {
  count                  = var.create ? 3 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway[0].id
  depends_on             = [aws_internet_gateway.internet_gateway]
}

# Asociar subredes públicas con la tabla de enrutamiento pública
resource "aws_route_table_association" "public_association" {
  count          = var.create ? 3 : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Tabla de enrutamiento para subredes privadas
resource "aws_route_table" "private" {
  count  = var.create ? 1 : 0
  vpc_id = aws_vpc.main[0].id
}

resource "aws_route" "private_nat_route" {
  count                  = var.create ? 3 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[0].id
  depends_on             = [aws_nat_gateway.nat_gateway]
}

# Asociar subredes privadas con la tabla de enrutamiento privada
resource "aws_route_table_association" "private_association" {
  count          = var.create ? 3 : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}
