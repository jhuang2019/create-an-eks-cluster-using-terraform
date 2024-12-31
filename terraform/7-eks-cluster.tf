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

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]
}

resource "null_resource" "update_eks_kubectl" {
  provisioner "local-exec" {
        command = "mv  ~/.kube/config  ~/.kube/config.bak ; mv ~/.config/argocd/config  ~/.config/argocd/config.bak; aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
    }

  depends_on = [aws_eks_cluster.eks_demo]
}
