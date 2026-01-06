packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }

    vagrant = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  profile       = "practice"
  associate_public_ip_address = true
  temporary_security_group_source_public_ip = true
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  ssh_timeout = "10m"
  ssh_interface = "public_ip"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = ["/usr/bin/cloud-init status --wait"]
  }
  provisioner "shell" {

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo ufw allow proto tcp from any to any port 22,80,443",
      "echo '<h1>Deployed via Packer</h1>' | sudo tee /var/www/html/index.html"
    ]
  }

  post-processor "vagrant" {}
  post-processor "compress" {
    format = "zip"
  }

}
