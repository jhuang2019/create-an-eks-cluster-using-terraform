variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  description = "The VPC Network Range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_2a_cidr" {
  description = "The private subnet 2a CIDR range"  
  type = string
  default = "10.0.0.0/19"
}

variable "private_subnet_2a_az" {
  description = "The private subnet 2a availability zone"  
  type = string
  default = "ap-southeast-2a" 
}

variable "private_subnet_2b_cidr" {
  description = "The private subnet 2b CIDR range"  
  type = string
  default = "10.0.32.0/19"
}

variable "private_subnet_2b_az" {
  description = "The private subnet 2b availability zone"  
  type = string
  default = "ap-southeast-2b" 
}

variable "public_subnet_2a_cidr" {
  description = "The public subnet 2a CIDR range"  
  type = string
  default = "10.0.64.0/19"
}

variable "public_subnet_2a_az" {
  description = "The public subnet 2a availability zone"  
  type = string
  default = "ap-southeast-2a" 
}

variable "public_subnet_2b_cidr" {
  description = "The public subnet 2b CIDR range"  
  type = string
  default = "10.0.96.0/19"
}

variable "public_subnet_2b_az" {
  description = "The public subnet 2b availability zone"  
  type = string
  default = "ap-southeast-2b" 
}

variable "eks_master_role" {
  description = "The name of the EKS cluster master role"  
  type = string
  default = "eks-cluster-master-role" 
}

variable "eks_node_group_role" {
  description = "The name of the EKS node group role"  
  type = string
  default = "eks-node-group-role" 
}

variable "cluster_name" {
  description = "The name of the EKS cluster" 
  type= string
  default="eks-demo"
}

variable "node_group_name" {
  description = "The name of the EKS node group" 
  type= string
  default="eks-node-group-on-demand"
}

variable "ecr_repo_name" {
  description = "The name of the ECR repo"
  type        = string
  default = "jen/my-nginx"
}