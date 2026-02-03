terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket       = "nikky-techies-devops-portfolio"
    key          = "global/iam/terraform.tfstate" # Different key for global resources
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}


data "aws_caller_identity" "current" {}

# Now you can use the Account ID anywhere without hardcoding it
# Example: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"

# 1. The OIDC Provider
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# 2. The Shared Role
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