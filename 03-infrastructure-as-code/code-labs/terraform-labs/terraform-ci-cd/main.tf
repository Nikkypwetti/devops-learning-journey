provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_practice_bucket" {
  bucket = "nikky-devops-practice-2026-x1" # Change this name!
}