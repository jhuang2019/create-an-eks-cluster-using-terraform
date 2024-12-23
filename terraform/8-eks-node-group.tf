resource "aws_eks_node_group" "private_nodes" {
  cluster_name = aws_eks_cluster.eks_demo.name

  node_group_name = var.node_group_name
  node_role_arn = aws_iam_role.eks_node_group_role.arn

  subnet_ids = [
    aws_subnet.private_2a.id,
    aws_subnet.private_2b.id
  ]

  #ami_type = "AL2_x86_64"
  capacity_type ="ON_DEMAND"
  instance_types = ["t3.small"]

  labels = {
    role = "general"
  }

  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "eks-demo"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
  ]

}