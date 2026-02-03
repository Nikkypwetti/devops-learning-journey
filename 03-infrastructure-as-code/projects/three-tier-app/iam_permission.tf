# 1. Reference the Global Role (Identity)
data "aws_iam_role" "shared_role" {
  name = "GitHubAction-Terraform-Managed-Role"
}

# 2. Reference Account ID for dynamic ARNs
data "aws_caller_identity" "current" {}

# 3. Create the Three-Tier Permission Brick
resource "aws_iam_policy" "three_tier_permissions" {
  name        = "ThreeTierProjectPermissions"
  description = "Permissions for Three-Tier Networking, EC2, and RDS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Permission to manage the state bucket for this project
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetBucketLocation"]
        Resource = "arn:aws:s3:::${var.aws_s3_bucket}"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${var.aws_s3_bucket}/*"
      },
      {
        # Permission for networking and servers (The "Three Tiers")
        Effect = "Allow"
        Action = [
          "ec2:*",
          "rds:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "ec2:DetachNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "iam:CreateServiceLinkedRole" # Required for ALB first-time setup
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

