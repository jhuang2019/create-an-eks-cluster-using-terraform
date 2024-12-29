provider "aws" {
  region = var.region
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_demo.id
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host = aws_eks_cluster.eks_demo.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_demo.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.cluster.token
}


provider "kubectl" {
  # Configuration options
  host  = aws_eks_cluster.eks_demo.endpoint
  cluster_ca_certificate =  base64decode(aws_eks_cluster.eks_demo.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.50.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
