#!/bin/bash

# 1. Install Trivy (Ubuntu/Debian Official Method)
echo "Installing Trivy security scanner..."
sudo apt-get update
sudo apt-get install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install -y trivy

# 2. Update .pre-commit-config.yaml
echo "Updating pre-commit configuration..."
if [ -f .pre-commit-config.yaml ]; then
    # Replace the deprecated tfsec id with trivy
    sed -i 's/id: terraform_tfsec/id: terraform_trivy/g' .pre-commit-config.yaml
    echo "Hook ID updated to terraform_trivy."
else
    echo "Error: .pre-commit-config.yaml not found!"
    exit 1
fi

# 3. Synchronize and Auto-update hooks
echo "Syncing hooks and pulling latest versions..."
pre-commit autoupdate
pre-commit install

echo "Done! You can now run: pre-commit run --all-files"