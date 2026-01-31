# 🚀 Terraform CI/CD & Security Integration

## 📋 Overview

Successfully migrated a local Terraform workflow to a fully automated GitHub Actions pipeline. This lab focused on "Shifting Left" by integrating security and linting directly into the CI/CD process before infrastructure deployment.

## 🏗️ Architecture

    Remote Backend: AWS S3 with native state locking (use_lockfile).

    CI/CD Tool: GitHub Actions.

    Security Scanners: Trivy (formerly tfsec) for vulnerability detection.

    Linters: TFLint with AWS-specific rulesets.

## 🛠️ Key Technical Implementations

1. Secure Remote State

Migrated from local state to an S3 backend. Solved the "bootstrapping" problem by manually creating a persistent Backend Store bucket to house the .tfstate files, ensuring a stable foundation for automation.

2. Multi-Stage Pipeline Logic

Configured terraform.yml with advanced path filtering to support a monorepo structure.

    Path Filtering: **/terraform-ci-cd/** ensures the pipeline only triggers for relevant infrastructure changes.

    Manual Triggers: Integrated workflow_dispatch for on-demand runs.

3. Infrastructure Quality Gates

    TFLint: Enforced tagging standards and provider version pinning.

    Trivy/tfsec: Automated scanning for "High" and "Critical" S3 misconfigurations (e.g., blocking public access, enforcing encryption).

## 💻 Code Snippet: The "Secure" S3 Bucket

Terraform

# Standardized Bucket with Security & Versioning
resource "aws_s3_bucket" "my_practice_bucket" {
  bucket = var.bucket_name

# tfsec:ignore:aws-s3-enable-bucket-logging
  tags = {
    Environment = "Dev"
    Owner       = "Nikky"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.my_practice_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## 🧠 Lessons Learned

    Chicken & Egg Problem: Understood why the backend bucket must be created before the Terraform init phase can succeed in a pipeline.

    GitHub API Rate Limits: Learned to use ${{ secrets.GITHUB_TOKEN }} to authenticate TFLint and avoid 403 errors during plugin installation.

    Path Wildcards: Mastered the use of ** patterns in GitHub Actions to make monorepo workflows more resilient to folder structure changes.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.my_practice_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy resources in | `string` | `"us-east-1"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket to create | `string` | `"nikky-devops-practice-2026-x1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->