variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "vault_password_file" {
  type    = string
  default = ".ansible_vault_pass"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}