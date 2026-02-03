# This is the URL you will use to visit your website!
output "application_url" {
  value = module.alb.alb_dns_name
}

output "current_account_id" {
  value = data.aws_caller_identity.current.account_id
}