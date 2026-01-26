# 1. Create the OIDC Identity Provider
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  # AWS now handles thumbprints automatically in the background
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] 
}

# 2. Define the IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "GitHubAction-Terraform-Managed-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:Nikkypwetti/devops-learning-journey:*"
          }
        }
      }
    ]
  })
}

# 3. Attach S3 Full Access (The "Key" to your portfolio)
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy" "cloudfront_invalidation" {
  name = "CloudFrontInvalidationPolicy"
  role = aws_iam_role.github_actions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "cloudfront:CreateInvalidation"
        Effect   = "Allow"
        Resource = "arn:aws:cloudfront::701573843345:distribution/E3N2N64Y0SFSQI"
      }
    ]
  })
}