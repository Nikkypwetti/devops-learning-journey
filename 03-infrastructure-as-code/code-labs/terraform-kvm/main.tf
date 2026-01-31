terraform {
  required_version = ">= 1.0.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.1"
    }
  }
}

# provider "libvirt" {
#   uri = "qemu:///system"
# }

# # Use a very simple volume name without dashes first
# resource "libvirt_volume" "disk_v1" {
#   name   = "nginx_v1.qcow2"
#   pool   = "default"
#   source = "/mnt/storage/packer-builds/nginx-v1.qcow2"
# }

# resource "libvirt_domain" "web_server" {
#   name   = "web-server-tf"
#   memory = "2048"
#   vcpu   = 2

#   # Essential: This tells the provider which virtualization to use
#   type = "kvm"

#   # We are keeping these blocks exactly as the provider documentation 
#   # for v0.9.1 specifies.
#   network_interface {
#     network_name = "default"
#   }

#   disk {
#     volume_id = libvirt_volume.disk_v1.id
#   }

#   console {
#     type        = "pty"
#     target_port = "0"
#     target_type = "serial"
#   }
# }