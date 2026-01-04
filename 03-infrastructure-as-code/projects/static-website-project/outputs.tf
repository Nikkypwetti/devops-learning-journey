output "s3_website_endpoint" {
  value = module.my_static_website.s3_website_endpoint
}

output "cloudfront_url" {
  value       = module.my_static_website.cloudfront_url
  description = "The domain name of the CloudFront distribution"
}

