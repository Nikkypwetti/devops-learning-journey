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

resource "aws_s3_bucket" "my_practice_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "Dev"
    Owner       = "Nikky"
  }
}
