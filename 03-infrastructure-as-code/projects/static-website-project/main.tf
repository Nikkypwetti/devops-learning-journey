module "my_static_website" {
  source      = "./modules/static-website"
  bucket_name = var.bucket_name

}