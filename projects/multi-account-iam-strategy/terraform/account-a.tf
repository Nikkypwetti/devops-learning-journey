# In a new file terraform/account-a.tf
provider "aws" {
  region = var.region
  alias  = "account_a"
  profile = "account-a"
}

resource "aws_iam_group" "developers" {
  provider = aws.account_a
  name = "CrossAccountDevelopers"
}

resource "aws_iam_group_policy" "allow_assume_role" {
  provider = aws.account_a
  name   = "AllowAssumeCrossAccountRole"
  group  = aws_iam_group.developers.name
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = "arn:aws:iam::${var.account_b_id}:role/CrossAccountAccessRole"
      }
    ]
  })
}