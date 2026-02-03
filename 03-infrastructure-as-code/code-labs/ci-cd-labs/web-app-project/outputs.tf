# output "github_actions_role_arn" {
#   description = "The ARN of the IAM Role for GitHub Actions. Copy this to your GitHub Secrets."
#   value       = aws_iam_role.github_actions_role.arn
# }

# output "oidc_provider_arn" {
#   description = "The ARN of the OIDC Provider."
#   value       = aws_iam_openid_connect_provider.github.arn
# }