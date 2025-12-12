# #!/bin/bash
# yum update -y
# curl -sL https://rpm.nodesource.com/setup_14.x | bash -
# yum install -y nodejs git
# git clone https://github.com/your-repo/web-app.git
# cd web-app
# npm install
# INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) node app.js

#!/bin/bash
set -e

# Update system
dnf update -y

# Install Git
dnf install -y git

# Install Node.js 18 (stable)
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
dnf install -y nodejs

# Install PM2
npm install -g pm2

# Switch to ec2-user home
cd /home/ec2-user

# Clone your repo
git clone https://github.com/Nikkypwetti/devops-learning-journey.git

# Go into the load balancer project folder
cd devops-learning-journey/01-cloud-foundations/week-02-compute-services/labs/load-balancer-project

# Create .env
cat <<EOF > .env
APP_PORT=3000
EOF

# Install dependencies
npm install

# Fix permissions so PM2 works
chown -R ec2-user:ec2-user /home/ec2-user

# Start PM2 as ec2-user
sudo -u ec2-user pm2 start app.js --name ha-web-app

# Save process
sudo -u ec2-user pm2 save

# Enable pm2 startup on boot
sudo -u ec2-user pm2 startup systemd -u ec2-user --hp /home/ec2-user


# Note:
use dnf instead of yum for Amazon Linux 2023
