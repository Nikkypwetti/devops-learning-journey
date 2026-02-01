# 1. Create the OIDC Identity Provider
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
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
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })
}

# 2. Create a specific policy for ONLY your portfolio bucket
resource "aws_iam_role_policy" "s3_limited_access" {
  name = "S3PortfolioUploadPolicy"
  role = aws_iam_role.github_actions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation" # Added this for 'terraform init'
        ],
        # ListBucket applies to the BUCKET itself
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        # These apply to the OBJECTS inside the bucket
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        # Don't forget DynamoDB permissions for state locking!
        Resource = "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/terraform-state-locking"
      }
    ]
  })
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
        Resource = "arn:aws:cloudfront::${var.aws_account_id}:distribution/${var.cloudfront_distribution_id}"
      }
    ]
  })
}

# 3. Create a policy for EC2 testing lab
resource "aws_iam_role_policy" "ec2_testing_access" {
  name = "EC2TestingLabPolicy"
  role = aws_iam_role.github_actions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # 1. Read-only actions that MUST use "*"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ec2:DescribeImages"
        ]
        Resource = "*"
      },
      {
        # 2. Restrict RunInstances by Instance Type (Limits cost/damage)
        Effect = "Allow"
        Action = "ec2:RunInstances"
        Resource = [
          "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:instance/*",
          "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:network-interface/*",
          "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group/*",
          "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:volume/*",
          "arn:aws:ec2:${var.aws_region}::image/ami-*",
          "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/*"
        ]
        Condition = {
          "StringEquals" = {
            "ec2:InstanceType" = ["t2.micro", "t3.micro"] # Limits to Free Tier
          }
        }
      },
      {
        # 3. Restrict Management actions to your specific Region
        Effect = "Allow"
        Action = [
          "ec2:TerminateInstances",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
        ]
        Resource = "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:*"
      }
    ]
  })
}