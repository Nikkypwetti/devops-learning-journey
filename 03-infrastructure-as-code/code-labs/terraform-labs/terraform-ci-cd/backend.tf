terraform {
  backend "s3" {
    bucket         = "nikky-terraform-backend-store" # The manual bucket
    key            = "terraform-ci-cd/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}