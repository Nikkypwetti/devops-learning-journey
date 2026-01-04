# Create S3 bucket for static website hosting
resource "aws_s3_bucket" "static_website_bucket" {
  bucket = var.bucket_name # Ensure this is globally unique

  lifecycle {
    prevent_destroy = false
  }

    tags = local.common_tags
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.static_website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_access" {
  bucket = aws_s3_bucket.static_website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "s3-website-oac"
  description                       = "OAC for S3 Static Website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
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


# Upload all files from the /website directory
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/website/", "**/*")
  bucket   = aws_s3_bucket.static_website_bucket.id # Make sure this matches your bucket name
  key      = each.value                             # This will be the file name in S3
  source   = "${path.module}/website/${each.value}"

  # This logic picks the right content_type or defaults to "text/plain"
  content_type = lookup(local.mime_types, element(split(".", each.value), length(split(".", each.value)) - 1), "application/octet-stream")

  # This ensures files only re-upload if the content changes
  etag = filemd5("${path.module}/website/${each.value}")
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.bucket_name} static website"
  default_root_object = "index.html"

  # Cache Behavior: How CloudFront handles requests
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # redirect-to-https makes your site secure
    viewer_protocol_policy = "redirect-to-https"

    # TTLs: How long files stay in cache (in seconds)
    min_ttl     = 0
    default_ttl = 3600  # 1 hour
    max_ttl     = 86400 # 24 hours
  }

  price_class = "PriceClass_100" # Use the least expensive edge locations

  # For a practice project, we use the free CloudFront SSL certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "Learning"
  }
}