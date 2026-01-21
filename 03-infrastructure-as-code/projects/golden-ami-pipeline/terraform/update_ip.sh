#!/bin/bash

# 1. Get your current public IP
CURRENT_IP=$(curl -s http://checkip.amazonaws.com)

# 2. Check if the IP was retrieved successfully
if [ -z "$CURRENT_IP" ]; then
  echo "Error: Could not retrieve public IP."
  exit 1
fi

# 3. Create or overwrite the terraform.tfvars file
echo "my_ip = \"${CURRENT_IP}/32\"" > terraform.tfvars

echo "Success: terraform.tfvars updated with IP: ${CURRENT_IP}"