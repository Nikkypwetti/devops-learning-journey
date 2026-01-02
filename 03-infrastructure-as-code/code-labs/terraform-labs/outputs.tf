output "final_public_ip" {
  description = "The public IP address of the server" 
  value = module.my_ec2.public_ip
}

output "ssh_connection_string" {
  value = "ssh -i ${replace(var.public_key_path, ".pub", ".pem")} ec2-user@${module.my_ec2.public_ip}"
}