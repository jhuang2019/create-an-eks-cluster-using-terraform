output "test_policy_arn" {
  value = aws_iam_role.test_oidc.arn
}

output "eks_cluster_autoscaler_arn" {
  value = aws_iam_role.eks_cluster_autoscaler.arn
}

output "github_actions_arn" {
  value = aws_iam_role.github_actions.arn
}