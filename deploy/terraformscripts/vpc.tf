resource "aws_vpc" "gfg-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.gfg-vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.public-subnet-az
  tags = {
    Name = "gfg-48-public-subnet"
  }
  map_public_ip_on_launch  = true
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.gfg-vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.private-subnet-az
  tags = {
    Name = "gfg-48-private-subnet"
  }
  map_public_ip_on_launch  = false
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.gfg-vpc.id

  tags = {
    Name = "gfg-48-internet-gateway"
  }
}

resource "aws_route_table" "publict-rt" {
  vpc_id = aws_vpc.gfg-vpc.id

  route {
    cidr_block = var.route_table_allowed_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "gfg-48-public-route-table"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.publict-rt.id
}

resource "aws_eip" "gfg-eip" {
  domain   = "vpc"
  tags = {
    Name = "gfg-48-eip"
  }
}

resource "aws_nat_gateway" "gfg-nat-gateway" {
  allocation_id = aws_eip.gfg-eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "gfg-48-nat-gateway"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.gfg-vpc.id

  route {
    cidr_block = var.route_table_allowed_cidr
    gateway_id = aws_nat_gateway.gfg-nat-gateway.id
  }

  tags = {
    Name = "gfg-48-private-route-table"
  }
}


resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rt.id
}
