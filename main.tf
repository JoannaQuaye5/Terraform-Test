resource "aws_vpc" "ama_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ama_vpc"
  }
}

resource "aws_subnet" "pub_sub" {
  vpc_id     = aws_vpc.ama_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pub_sub"
  }
}

resource "aws_subnet" "priv_sub" {
  vpc_id     = aws_vpc.ama_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "priv_sub"
  }
}

resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.ama_vpc.id

  tags = {
    Name = "pub_route_table"
  }
}

resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.ama_vpc.id

  tags = {
    Name = "priv_route_table"
  }
}

resource "aws_route_table_association" "pub_route_table_association" {
  subnet_id      = aws_subnet.pub_sub.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "priv_route_table_association" {
  subnet_id      = aws_subnet.priv_sub.id
  route_table_id = aws_route_table.priv_route_table.id
}

resource "aws_internet_gateway" "ama_IGW" {
  vpc_id = aws_vpc.ama_vpc.id

  tags = {
    Name = "ama_IGW"
  }
}

resource "aws_route" "pub_internet_igw_route" {
  route_table_id            = aws_route_table.pub_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.ama_IGW.id
}
