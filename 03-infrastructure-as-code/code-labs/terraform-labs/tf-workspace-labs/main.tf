terraform {
  required_version = ">= 1.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "nikky-techies-${terraform.workspace}-bucket-21"

}

# Fix: Prevent the bucket from ever being made public
resource "aws_s3_bucket_public_access_block" "block_pub" {
  bucket                  = aws_s3_bucket.my_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Fix: Enable encryption
# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}