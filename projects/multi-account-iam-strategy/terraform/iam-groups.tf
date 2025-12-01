# IAM Groups in Management Account
resource "aws_iam_group" "management_groups" {
  for_each = {
    "SecurityAdmins"     = "Security team with elevated privileges"
    "NetworkAdmins"      = "Network infrastructure team"
    "BillingAdmins"      = "Finance team for cost management"
    "Auditors"          = "Internal and external auditors"
    "BreakGlassAdmins"  = "Emergency access administrators"
  }

  provider = aws.management
  name     = each.key
  path     = "/"
}

# IAM Groups in Production Account
resource "aws_iam_group" "production_groups" {
  for_each = {
    "ProductionAdmins"   = "Production environment administrators"
    "ProductionDevelopers" = "Developers with production access"
    "ProductionSupport"  = "Support team for production issues"
  }

  provider = aws.production
  name     = each.key
  path     = "/"
}

# IAM Groups in Development Account
resource "aws_iam_group" "development_groups" {
  for_each = {
    "Developers"        = "Application developers"
    "DevOpsEngineers"   = "Infrastructure and deployment engineers"
    "QAEngineers"       = "Quality assurance team"
  }

  provider = aws.development
  name     = each.key
  path     = "/"
}