module "my_ec2" {
  source          = "./modules/module-1"
  instance_name   = var.instance_name
  instance_type   = var.instance_type
  key_name        = var.key_name
  public_key_path = var.public_key_path
}
