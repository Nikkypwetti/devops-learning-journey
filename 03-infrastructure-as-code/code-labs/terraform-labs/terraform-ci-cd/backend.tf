terraform {
  backend "s3" {
    bucket         = "nikky-devops-practice-2026-x1" 
    key            = "devops-journey/terraform.tfstate"
    region         = "us-east-1"
    # profile        = "learning"
    use_lockfile   = true                         # For state locking
    encrypt        = true                         # Recommended for security
  }
}