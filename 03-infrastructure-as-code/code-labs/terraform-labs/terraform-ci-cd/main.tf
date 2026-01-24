terraform {
  required_version = ">= 1.5.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or whichever version you are using
    }
  }
}
provider "aws" {
  region = var.aws_region
}

# 1. The Bucket
resource "aws_s3_bucket" "my_practice_bucket" {
  bucket = var.bucket_name

  # tfsec:ignore:aws-s3-enable-bucket-logging
  tags = {
    Environment = "Dev"
    Owner       = "Nikky"
  }
}

# 2. Block all public access 
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.my_practice_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Enable Encryption 
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.my_practice_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      # tfsec:ignore:aws-s3-encryption-customer-key
      sse_algorithm = "AES256"
    }
  }
}

# 4. Enable Versioning 
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_practice_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
