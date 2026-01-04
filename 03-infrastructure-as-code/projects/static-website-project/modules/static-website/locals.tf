# Naming and IDs
locals {
  origin_id = "S3-${var.bucket_name}"
  common_tags = {
    Project   = "Day6-S3-Website"
    ManagedBy = "Terraform"
  }
}

# Web Assets configuration
locals {
  mime_types = {
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "gif"  = "image/gif"
    "svg"  = "image/svg+xml"
    "ico"  = "image/x-icon"
    "json" = "application/json"
    "pdf"  = "application/pdf"
    "txt"  = "text/plain"
  }
}