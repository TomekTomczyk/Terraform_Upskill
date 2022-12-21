resource "aws_vpc" "ttomczyk_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "int_gateway" {
  vpc_id = aws_vpc.ttomczyk_vpc.id

  tags = {
    Name = var.int_gateway_name
  }
}

resource "aws_eip" "aws_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.aws_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    nat_gateway_name = var.nat_gateway_name
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.ttomczyk_vpc.id
  cidr_block        = var.public_subnet1_cidr_block
  availability_zone = var.subnet1_availability_zone

  tags = {
    Name = var.public_subnet1_name
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.ttomczyk_vpc.id
  cidr_block        = var.public_subnet2_cidr_block
  availability_zone = var.subnet2_availability_zone

  tags = {
    Name = var.public_subnet2_name
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.ttomczyk_vpc.id
  cidr_block        = var.private_subnet1_cidr_block
  availability_zone = var.subnet1_availability_zone

  tags = {
    Name = var.private_subnet1_name
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.ttomczyk_vpc.id
  cidr_block        = var.private_subnet2_cidr_block
  availability_zone = var.subnet2_availability_zone

  tags = {
    Name = var.private_subnet2_name
  }
}

resource "aws_route_table" "aws_route_table_public" {
  vpc_id = aws_vpc.ttomczyk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gateway.id
  }

  tags = {
    Name = var.route_table_public_name
  }
}

resource "aws_route_table" "aws_route_table_private" {
  vpc_id = aws_vpc.ttomczyk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = var.route_table_private_name
  }
}

resource "aws_route_table_association" "aws_route_table_association_public1" {
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.aws_route_table_public.id
}

resource "aws_route_table_association" "aws_route_table_association_public2" {
  subnet_id = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.aws_route_table_public.id
}

resource "aws_route_table_association" "aws_route_table_association_private1" {
  subnet_id = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.aws_route_table_private.id
}

resource "aws_route_table_association" "aws_route_table_association_private2" {
  subnet_id = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.aws_route_table_private.id
}
