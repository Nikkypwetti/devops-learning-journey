variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "playbook_file_path" {
  type    = string
  default = "" # Leave empty or keep your local path
}

variable "ansible_roles_path" {
  type    = string
  default = "" # Leave empty or keep your local path
}

variable "vault_password_file" {
  type    = string
  default = ".ansible_vault_pass"
}

