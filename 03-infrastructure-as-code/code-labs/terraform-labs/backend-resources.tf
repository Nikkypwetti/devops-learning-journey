# Create S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "nikky-techies-terraform-state-bucket-21"

  lifecycle {
    prevent_destroy = false
  }
}

# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Fix: S3 Lifecycle Configuration (CKV2_AWS_61)
resource "aws_s3_bucket_lifecycle_configuration" "state_lifecycle" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  rule {
    id     = "expire-old-versions"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}


#protect the S3 bucket with Public Access Block
resource "aws_s3_bucket_public_access_block" "state_bucket_access" {
  bucket                  = aws_s3_bucket.terraform_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create DynamoDB table for backend locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Fix: Point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true # Fix: Encrypt DynamoDB
  }
}
