1. The OIDC Provider Error (EntityAlreadyExists)

The Problem: You tried to create the GitHub OIDC provider, but it already exists in your AWS account (likely from our previous sessions where we set up your IAM role). AWS only allows one OIDC provider per URL (https://token.actions.githubusercontent.com).

The Fix: You don't need to "create" it again. You should import it into your Terraform state so Terraform knows it's already managed.

Run this command in your terminal:
Bash

terraform import aws_iam_openid_connect_provider.github arn:aws:iam::<account_id>:oidc-provider/token.actions.githubusercontent.com

Option A: Import the Role (Recommended)

Tell Terraform that you already own this role so it can manage it moving forward. Run this command:
Bash

terraform import aws_iam_role.github_actions_role GitHubAction-Terraform-Managed-Role