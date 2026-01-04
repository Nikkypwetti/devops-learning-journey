terraform {
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