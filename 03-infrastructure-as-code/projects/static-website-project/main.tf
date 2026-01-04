module "my_static_website" {
  source      = "./modules/static-website"
  bucket_name = var.bucket_name
  aws_region  = var.aws_region
  aws_profile = var.aws_profile

}