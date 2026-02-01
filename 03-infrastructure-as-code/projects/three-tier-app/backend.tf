terraform {
  backend "s3" {
    bucket       = "nikky-three-tier-portfolio" # Name of your S3 bucket
    key          = "three-tier-app/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
  