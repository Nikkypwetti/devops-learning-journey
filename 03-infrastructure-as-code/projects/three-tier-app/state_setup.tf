resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  # Fix: Point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Fix: Encryption 
  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}

#create S3 bucket for terraform state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "nikky-three-tier-portfolio"

  # Optional: Prevents accidental deletion of your state
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "state_bucket_access" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = "nikky-three-tier-portfolio" # Use your actual bucket name
  versioning_configuration {
    status = "Enabled"
  }
}

# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = "nikky-three-tier-portfolio" # Use your actual bucket name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

