# Managed Policies in Management Account
resource "aws_iam_policy" "management_policies" {
  for_each = {
    "BreakGlassEmergency" = file("${path.module}/../iam-policies/break-glass-emergency.json")
    "ReadOnlyAudit"       = file("${path.module}/../iam-policies/read-only-audit.json")
    "CostExplorerReadOnly" = file("${path.module}/../iam-policies/cost-explorer-readonly.json")
  }

  provider    = aws.management
  name        = each.key
  description = "Custom IAM policy for ${each.key}"
  policy      = each.value
}

# Managed Policies in Development Account
resource "aws_iam_policy" "development_policies" {
  for_each = {
    "PowerUserDev" = file("${path.module}/../iam-policies/power-user-dev.json")
  }

  provider    = aws.development
  name        = each.key
  description = "Custom IAM policy for ${each.key}"
  policy      = each.value
}