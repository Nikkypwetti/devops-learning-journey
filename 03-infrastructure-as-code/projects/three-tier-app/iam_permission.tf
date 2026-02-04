# 1. Reference the Global Role (Identity)
data "aws_iam_role" "shared_role" {
  name = "GitHubAction-Terraform-Managed-Role"
}

# 2. Reference Account ID for dynamic ARNs
data "aws_caller_identity" "current" {}

# 3. Create the Three-Tier Permission Brick
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
          "arn:aws:s3:::${var.aws_s3_bucket}/*",
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

# 4. Snap it onto the Shared Role
resource "aws_iam_role_policy_attachment" "attach_three_tier" {
  role       = data.aws_iam_role.shared_role.name
  policy_arn = aws_iam_policy.three_tier_permissions.arn
}

