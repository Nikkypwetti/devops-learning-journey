# terraform {
#   backend "s3" {
#     bucket         = "nikky-terraform-state-2026" 
#     key            = "devops-journey/terraform.tfstate"
#     region         = "us-east-1"
#     profile        = "learning"
#     use_lockfile   = true                         # For state locking
#     encrypt        = true                         # Recommended for security
#   }
# }