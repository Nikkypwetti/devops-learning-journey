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

# Update System
dnf update -y

# Install Node.js, npm, git
dnf install -y nodejs npm git

# Install PM2
npm install -g pm2

# Get EC2 Metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Clone GitHub Repository
cd /home/ec2-user
git clone https://github.com/Nikkypwetti/devops-learning-journey.git

# Go into the load balancer project folder
cd devops-learning-journey/01-cloud-foundations/week-02-compute-services/labs/load-balancer-project

# Create .env
cat <<EOF > .env
INSTANCE_ID=$INSTANCE_ID
AVAILABILITY_ZONE=$AVAILABILITY_ZONE
APP_PORT=3000
EOF

# Install dependencies
npm install

# Start app with PM2
pm2 start app.js --name ha-web-app
pm2 save
pm2 startup systemd

# Note:
use dnf instead of yum for Amazon Linux 2023
