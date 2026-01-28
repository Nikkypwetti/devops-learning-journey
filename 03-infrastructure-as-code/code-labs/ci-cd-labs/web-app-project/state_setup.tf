resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = "nikky-techies-devops-portfolio" # Use your actual bucket name
  versioning_configuration {
    status = "Enabled"
  }
}
