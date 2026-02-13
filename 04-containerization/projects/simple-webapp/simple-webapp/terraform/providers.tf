terraform {
  required_version = ">= 1.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # New HTTP provider to get your IP address
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }

  backend "s3" {
    bucket       = "nikky-simple-webapp-state-storage" # Change to your unique bucket name
    key          = "state/terraform.tfstate"
    region       = "us-east-1" # Change if your bucket is in a different region
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region

}
