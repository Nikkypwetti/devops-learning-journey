terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Look up the global role
data "aws_iam_role" "shared_role" {
  name = "GitHubAction-Terraform-Managed-Role"
}

#Define the EC2 Policy standalone
#Create a policy for EC2 testing lab
resource "aws_iam_policy" "ec2_testing_access" {
  name = "EC2TestingLabPolicy"

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

# Attach the Lego brick to the role
resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = data.aws_iam_role.shared_role.name
  policy_arn = aws_iam_policy.ec2_testing_access.arn
}