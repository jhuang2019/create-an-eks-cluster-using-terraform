# Create a public subnet 2a
resource "aws_subnet" "public_2a" {
  vpc_id = aws_vpc.eks_test_vpc.id
  cidr_block = var.public_subnet_2a_cidr
  availability_zone = var.public_subnet_2a_az
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-ap-southeast-2a"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  } 
}

# Create a public subnet 2b
resource "aws_subnet" "public_2b" {
  vpc_id = aws_vpc.eks_test_vpc.id
  cidr_block = var.public_subnet_2b_cidr
  availability_zone = var.private_subnet_2b_az
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-ap-southeast-2b"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  } 
}

# Crreate a private subnet 2a
resource "aws_subnet" "private_2a" {
  vpc_id = aws_vpc.eks_test_vpc.id
  cidr_block = var.private_subnet_2a_cidr 
  availability_zone =var.private_subnet_2a_az

  tags = {
    "Name" = "private-ap-southeast-2a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Create a private subnet 2b
resource "aws_subnet" "private_2b" {
  vpc_id = aws_vpc.eks_test_vpc.id
  cidr_block = var.private_subnet_2b_cidr 
  availability_zone =var.private_subnet_2b_az

  tags = {
    "Name" = "private-ap-southeast-2b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}