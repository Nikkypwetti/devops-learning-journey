#
data "aws_caller_identity" "current" {}

# Now you can use the Account ID anywhere without hardcoding it
# Example: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"

# 1. The OIDC Provider
# --- IDENTITY FOUNDATION ---
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions_role" {
  name = "GitHubAction-Terraform-Managed-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRoleWithWebIdentity"
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Condition = {
        StringLike = { "token.actions.githubusercontent.com:sub" = "repo:Nikkypwetti/devops-learning-journey:*" }
      }
    }]
  })
}

# --- PROJECT BRICK 1: Three-Tier App ---
resource "aws_iam_policy" "three_tier_permissions" {
  name        = "ThreeTierProjectPermissions"
  description = "Refined permissions for S3 Sync, State, and Global EC2 Discovery"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning"
        ]
        # Include ALL buckets the GitHub Action needs to 'see'
        Resource = [
          "arn:aws:s3:::nikky-three-tier-portfolio",
          "arn:aws:s3:::nikky-techies-devops-portfolio"
        ]
      },
      # 2. Full Object Permissions for State and Sync
      {
        Effect = "Allow"
        Action = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
        Resource = [
          "arn:aws:s3:::nikky-three-tier-portfolio/*",
          "arn:aws:s3:::nikky-techies-devops-portfolio/*"
        ]
      },
      # 3. EC2 Read-Only Permissions (Global Discovery)
      {
        # These actions do NOT support region/resource conditions well
        Effect = "Allow"
        Action = [
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeAvailabilityZones"
        ]
        Resource = "*"
      },
      # 4. Regional Tiered Permissions
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "rds:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "iam:CreateServiceLinkedRole"
        ]
        Resource = "*"
        Condition = {
          "StringEquals" : { "aws:RequestedRegion" : "us-east-1" }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_three_tier" {
  role       = aws_iam_role.github_actions_role.name # Direct reference
  policy_arn = aws_iam_policy.three_tier_permissions.arn
}

# --- PROJECT BRICK 2: Web App ---
resource "aws_iam_policy" "web_app_s3" {
  name = "WebAppS3Access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]
      Resource = [
        "arn:aws:s3:::nikky-techies-devops-portfolio",
        "arn:aws:s3:::nikky-techies-devops-portfolio/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_web_app_s3" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.web_app_s3.arn
}

resource "aws_iam_policy" "web_app_cf" {
  name = "WebAppCloudFrontAccess"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "cloudfront:CreateInvalidation"
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_web_app_cf" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.web_app_cf.arn
}