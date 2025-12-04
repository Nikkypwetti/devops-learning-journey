output "role_arn" {
  description = "ARN of the cross-account role"
  value       = aws_iam_role.cross_account_role.arn
}

output "policy_arn" {
  description = "ARN of the created policy"
  value       = aws_iam_policy.cross_account_readonly.arn
}