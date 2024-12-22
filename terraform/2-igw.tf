# Create an internet gateway
resource "aws_internet_gateway" "eks_test_igw" {
    vpc_id = aws_vpc.eks_test_vpc.id

    tags = {
      Name = "EKS Test Internet Gateway"  
    }
}