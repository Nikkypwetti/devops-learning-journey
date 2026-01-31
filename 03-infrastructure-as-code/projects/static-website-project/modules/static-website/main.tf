terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}

# 1. Add S3 Versioning
resource "aws_s3_bucket_versioning" "static_versioning" {
  bucket = aws_s3_bucket.static_website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 2. Updated S3 Bucket
resource "aws_s3_bucket" "static_website_bucket" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = false
  }

  tags = local.common_tags
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.static_website_bucket.id
  index_document { suffix = "index.html" }
  error_document { key = "error.html" }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_access" {
  bucket                  = aws_s3_bucket.static_website_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# checkov:skip=CKV_AWS_145:Learning lab
# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket_server_side_encryption_configuration" "website_encryption" {
  bucket = aws_s3_bucket.static_website_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# trivy:ignore:AVD-AWS-0089
resource "aws_s3_bucket_logging" "example" {
  bucket        = aws_s3_bucket.static_website_bucket.id
  target_bucket = aws_s3_bucket.static_website_bucket.id
  target_prefix = "log/"
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "s3-website-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# checkov:skip=CKV_AWS_68:WAF not required for lab
# checkov:skip=CKV_AWS_86:Access logging not required for lab
# trivy:ignore:AVD-AWS-0011
# trivy:ignore:AVD-AWS-0010
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 84600
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "NG"]
    }
  }

  tags = { Environment = "Learning" }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket     = aws_s3_bucket.static_website_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.website_bucket_access]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_website_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_object" "website_files" {
  for_each     = fileset("${path.module}/website/", "**/*")
  bucket       = aws_s3_bucket.static_website_bucket.id
  key          = each.value
  source       = "${path.module}/website/${each.value}"
  content_type = lookup(local.mime_types, element(split(".", each.value), length(split(".", each.value)) - 1), "application/octet-stream")
  etag         = filemd5("${path.module}/website/${each.value}")
}