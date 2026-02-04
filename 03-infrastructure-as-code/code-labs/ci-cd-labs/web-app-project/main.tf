# 1. The S3 Bucket (The 'Hard Drive' for your site)
# trivy:ignore:AVD-AWS-0086 trivy:ignore:AVD-AWS-0087 trivy:ignore:AVD-AWS-0088 trivy:ignore:AVD-AWS-0091 trivy:ignore:AVD-AWS-0093 trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.aws_s3_bucket # Ensure this matches your actual bucket name
}

# Enable Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# 2. CloudFront (The 'Delivery Truck' for your site)
# trivy:ignore:AVD-AWS-0011
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.website_bucket.id}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website_bucket.id}"

    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}