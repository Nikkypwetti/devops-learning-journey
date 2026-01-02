# Day 4: State Management & Backends

## 🎯 Learning Objectives

- Understand Terraform state importance
- Learn local vs remote state
- Configure S3 backend with DynamoDB locking
- Practice state manipulation commands

### Video Tutorial (15 mins):

- [Understanding Terraform State](https://www.youtube.com/watch?v=R2S1Zxpb6UE)
- **Key Takeaways:**
  - State maps real resources to configuration
  - State contains metadata and dependencies
  - Never edit .tfstate manually

### Reading Material (10 mins):

- [Terraform State Documentation](https://developer.hashicorp.com/terraform/language/state)
- **Focus on:**
  - State purpose and structure
  - Backend configurations
  - State locking mechanisms

### Concept Examples (5 mins):

```hcl
# Local state (default)
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Remote state with S3
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

Commands Used
bash
terraform output - has a -json option, for obtaining either the full set of root module output values or a specific named output value from the latest state snapshot.

terraform show - has a -json option for inspecting the latest state snapshot in full, and also for inspecting saved plan files which include a copy of the prior state at the time the plan was made.