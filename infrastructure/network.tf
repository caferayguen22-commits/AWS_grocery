# Die ersten beiden Availability Zones der Region (eu-north-1a und eu-north-1b)
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

# Das eigene virtuelle Netzwerk (VPC) für GroceryMate
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "grocerymate-vpc"
  }
}

# Das Tor ins Internet für die öffentlichen Subnetze
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "grocerymate-igw"
  }
}

# 2 öffentliche Subnetze (je 1 pro AZ): hier laufen später EC2 und Load Balancer
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "grocerymate-public-${count.index + 1}"
  }
}

# 2 private Subnetze (je 1 pro AZ): hier liegt später die Datenbank, ohne Weg ins Internet
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)
  availability_zone = local.azs[count.index]

  tags = {
    Name = "grocerymate-private-${count.index + 1}"
  }
}

# Routentabelle für die öffentlichen Subnetze: alles Unbekannte (0.0.0.0/0) geht ins Internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "grocerymate-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
