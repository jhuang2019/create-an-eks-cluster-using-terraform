# Create a VPC
resource "aws_vpc" "eks_test_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "EKS Test VPC"
  }
}
