# Create an Elastic IP for NAT Gateway 1 
resource "aws_eip" "gw" {
  vpc = true 

  tags = {
    Name = "Elastic IP for Nat Gateway 1"
  }
}

# Create a NAT Gateway for the Availability Zone A
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.gw.id
  subnet_id     = aws_subnet.public_2a.id

  tags = {
    Name = "Nat Gateway 1 for the Availability Zone A"
  }

   depends_on    = [aws_internet_gateway.eks_test_igw]
}