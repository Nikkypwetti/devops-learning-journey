output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

output "cloudfront_url" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "The domain name of the CloudFront distribution"
}
