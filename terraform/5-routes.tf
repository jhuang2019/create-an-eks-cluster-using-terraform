# Route Table for the Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_test_igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Route table associations - Public
resource "aws_route_table_association" "public_2a" {
  subnet_id      = aws_subnet.public_2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2b" {
  subnet_id      = aws_subnet.public_2b.id
  route_table_id = aws_route_table.public.id
}

# First route table for the Private Subnet 2a

resource "aws_route_table" "private_2a" {
  vpc_id = aws_vpc.eks_test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private-Route-Table-2a"
  }
}

# Route table associations - Private Subnet 2a
resource "aws_route_table_association" "private_2a" {
  subnet_id      = aws_subnet.private_2a.id
  route_table_id = aws_route_table.private_2a.id
}

# Second route table for the Private Subnet 2b
resource "aws_route_table" "private_2b" {
  vpc_id = aws_vpc.eks_test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private-Route-Table-2b"
  }
}

# Route table associations - Private Subnet 2b
resource "aws_route_table_association" "private_2b" {
  subnet_id      = aws_subnet.private_2b.id
  route_table_id = aws_route_table.private_2b.id
}