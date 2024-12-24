resource "aws_eks_cluster" "eks_demo" {
  name = var.cluster_name
  role_arn = aws_iam_role.eks_master_role.arn
  version = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.public_2a.id,
      aws_subnet.public_2b.id,
      aws_subnet.private_2a.id,
      aws_subnet.private_2b.id  
    ]
  }  

  depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy]
}