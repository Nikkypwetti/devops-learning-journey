terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider for Account B (where we create the role)
provider "aws" {
  region = var.region
  alias  = "account_b"
  
  # Configure with your Account B credentials
  # You can use profile, access keys, or environment variables
  profile = "account-b"  # Or remove if using default
}

# Simple S3 read-only policy
resource "aws_iam_policy" "cross_account_readonly" {
  provider = aws.account_b
  
  name        = "CrossAccountS3ReadOnly"
  description = "Allows read-only S3 access from Account A"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

# Role that Account A can assume
resource "aws_iam_role" "cross_account_role" {
  provider = aws.account_b
  
  name = "CrossAccountAccessRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_a_id}:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  provider = aws.account_b
  
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.cross_account_readonly.arn
}