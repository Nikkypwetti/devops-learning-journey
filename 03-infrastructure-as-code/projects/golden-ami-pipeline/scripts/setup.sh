#!/bin/bash
set -e

# 1. Wait for Cloud-Init to finish (Crucial for AWS)
echo "Waiting for cloud-init to finish..."
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do 
    sleep 2
done

# 2. Update the system
echo "Updating Apt packages..."
sudo apt-get update -y

# 3. Pre-install Python3 (Ensures Ansible can run immediately)
echo "Installing Python3 and Pip..."
sudo apt-get install -y python3 python3-pip

echo "Setup complete. Remote instance is ready for Ansible."