#!/bin/bash
# AWS Launch Template Configuration
# This script deploys the Node.js application on EC2 instances
# Copy this ENTIRE script into AWS Launch Template User Data field

set -e

# System updates and package installation
dnf update -y
dnf install -y git

# Node.js installation
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
dnf install -y nodejs

# PM2 process manager
npm install -g pm2

# Application deployment as ec2-user
sudo -u ec2-user bash << 'DEPLOY_EOF'
cd /home/ec2-user

# Clone the repository
git clone https://github.com/Nikkypwetti/devops-learning-journey.git
cd devops-learning-journey

# Create environment configuration
cat > .env << 'ENV_CONFIG'
APP_PORT=3000
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
ENV_CONFIG

# Install Node.js dependencies
npm install

# Start application with PM2
pm2 start app.js --name ha-web-app
pm2 save
pm2 startup
DEPLOY_EOF

# Completion message
echo "Application deployment completed successfully"

Notes:
Use the code from app.js in the cloned repository.
Use dnf for Amazon Linux 2023 package management.
Use yum for Amazon Linux 2 package management.