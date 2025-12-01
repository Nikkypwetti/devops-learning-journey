# Cross-Account Roles
resource "aws_iam_role" "cross_account_roles" {
  for_each = {
    "SecurityAuditRole" = {
      account_id = "444444444444"
      policy_arn = aws_iam_policy.management_policies["ReadOnlyAudit"].arn
    }
    "DevToProdPromotionRole" = {
      account_id = "222222222222"
      policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    }
  }

  provider = aws.management
  name     = each.key

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${each.value.account_id}:root"
        }
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "role_policies" {
  for_each = aws_iam_role.cross_account_roles

  provider   = aws.management
  role       = each.value.name
  policy_arn = each.value.tags["policy_arn"]
}