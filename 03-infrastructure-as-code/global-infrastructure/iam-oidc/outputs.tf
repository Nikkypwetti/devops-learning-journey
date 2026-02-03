output "aws_account_id" {
  description = "The AWS Account ID currently being used"
  value       = data.aws_caller_identity.current.account_id
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions_role.arn
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.github.arn
}