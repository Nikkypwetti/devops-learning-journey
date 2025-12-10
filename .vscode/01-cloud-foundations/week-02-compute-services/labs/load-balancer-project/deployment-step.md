# Deployment Steps: High Availability Web Application

## 📋 Prerequisites

- AWS Free Tier Account
- AWS CLI configured (optional but recommended)
- Git installed
- SSH key pair for EC2

## 🚀 Step-by-Step Deployment

### **Step 1: Prepare Application Code**

```bash
# Clone or create project directory
mkdir ha-web-app
cd ha-web-app

# Initialize project
npm init -y
npm install express aws-sdk

# Copy app.js and package.json
# Create user-data.sh

Step 2: Create Launch Template

Via AWS Console:

    Navigate to EC2 → Launch Templates → Create launch template

    Template name: lb-web-app-template

    Template version description: Version 1 - Node.js app with ALB

Configure Template:

    AMI: Amazon Linux 2 AMI (HVM), SSD Volume Type

    Instance type: t2.micro (Free Tier eligible)

    Key pair: Select your existing key pair

    Security group: Create new security group:

        Name: ha-web-app-sg

        Rules:

            SSH: Port 22 (Your IP only)

            HTTP: Port 80 (0.0.0.0/0)

            Custom TCP: Port 3000 (ALB security group)

Step 3: Create Target Group

    Navigate to EC2 → Target Groups → Create target group

    Target type: Instances

    Target group name: ha-web-app-tg

    Protocol: HTTP

    Port: 3000

    VPC: Default VPC

    Health check path: /health

    Advanced health check settings:

        Healthy threshold: 2

        Unhealthy threshold: 2

        Timeout: 5 seconds

        Interval: 30 seconds

Step 4: Create Application Load Balancer

    Navigate to EC2 → Load Balancers → Create Load Balancer

    Select Application Load Balancer

    Name: lb-web-app-alb

    Scheme: Internet-facing

    IP address type: IPv4

    Listeners: HTTP on port 80

    Availability Zones: Select at least 2 AZs (us-east-1a, us-east-1b)

    Security group: Create new security group alb-sg:

        Allow HTTP from anywhere (0.0.0.0/0)

    Configure Routing: Select existing target group ha-web-app-tg

    Create

Step 5: Create Auto Scaling Group

    Navigate to EC2 → Auto Scaling Groups → Create Auto Scaling Group

    Name: lb-web-app-asg

    Launch template: Select ha-web-app-template

    Version: Latest

    Network: Default VPC

    Subnets: Select at least 2 subnets in different AZs

    Load balancing: Attach to existing load balancer

    Target group: Select ha-web-app-tg

    Health check type: ELB

    Health check grace period: 300 seconds

Configure Group Size:

    Desired capacity: 2

    Minimum capacity: 2

    Maximum capacity: 5

Scaling Policies:

    Add scaling policy:

        Policy type: Target tracking

        Metric: Average CPU utilization

        Target value: 70%

        Instances need: 300 seconds warm-up

Add Notifications (Optional):

    SNS topic for scaling events

Step 6: Test the Deployment

    Get ALB DNS Name:
    bash

# From AWS Console
# Or using AWS CLI
aws elbv2 describe-load-balancers --names ha-web-app-alb --query "LoadBalancers[0].DNSName" --output text

    Access Application:

        Open browser: http://ALB-DNS-NAME

        Refresh multiple times to see different instance IDs

    Health Check Endpoint:

        Access: http://ALB-DNS-NAME/health

        Should return: {"status": "healthy", "instance": "i-xxxxxx"}

Step 7: Monitor and Validate

Check CloudWatch Metrics:

    Navigate to CloudWatch → Metrics

    View:

        EC2 → Per-Instance Metrics → CPU Utilization

        ApplicationELB → Target Group Metrics

        Auto Scaling Group Metrics

Test Auto Scaling:

    Simulate Load (optional - for testing):
    bash

# SSH into instance and generate CPU load
stress --cpu 2 --timeout 300

    Monitor scaling activities in Auto Scaling Group events

Scale Manually (Test):

    In Auto Scaling Group, set Desired capacity to 3

    Wait for new instance to launch and register

    Verify in Target Group health checks

🛠️ Troubleshooting Guide
Common Issues and Solutions:

1. Instances Not Registering with Target Group:
bash

# SSH into instance and check:
sudo systemctl status lb-web-app.service
curl http://localhost:3000/health
sudo netstat -tlnp | grep :3000

2. Health Checks Failing:

    Check security group rules (ALB → Instance)

    Verify application is running on port 3000

    Check route table and network ACLs

3. Auto Scaling Not Working:

    Verify CloudWatch alarms exist

    Check scaling policy configurations

    Ensure instances are in running state

4. Application Not Accessible:
bash

# Check from instance:
curl http://localhost:3000

# Check security groups:
# 1. ALB security group should allow HTTP from anywhere
# 2. Instance security group should allow port 3000 from ALB security group

📊 Validation Checklist

    Application accessible via ALB DNS

    Health checks passing (Target Group)

    Multiple instances showing different IDs when refreshing

    Auto Scaling Group shows 2 running instances

    CloudWatch metrics visible

    Can SSH into instances using key pair

    Application logs available (journalctl -u lb-web-app.service)

🔧 Useful Commands
bash

# Get instance metadata
curl http://169.254.169.254/latest/meta-data/instance-id
curl http://169.254.169.254/latest/meta-data/placement/availability-zone

# Check application logs
sudo journalctl -u lb-web-app.service -f

# Test health endpoint
curl http://localhost:3000/health

# Monitor system resources
htop
df -h
free -m

📈 Cost Estimation (Free Tier)

✅ Free Tier Eligible Components:

    t2.micro instances (750 hours/month)

    ALB (750 hours/month)

    30 GB of EBS storage

    1 GB of data transfer out

⚠️ Monitor Costs:

    Set up billing alerts

    Use Cost Explorer

    Tag resources: Project=DevOps-Learning

🎯 Next Steps

    Add HTTPS:

        Request ACM certificate

        Update ALB listener to HTTPS (443)

    Add Monitoring:

        CloudWatch custom metrics

        SNS notifications


📁 Folder Structure for Your Project
text

load-balancer-project/
├── app.js                    # Main application
├── package.json             # Dependencies
├── deployment-steps.md      # Detailed deployment guide
├── user-data.sh            # Simplified boot script
├── README.md               # Project overview
└── screenshots/            # Add screenshots here
    ├── alb-console.png
    ├── asg-console.png
    └── app-browser.png

🔗 Quick Start Summary

    Copy these files to your project folder

    Update the GitHub URL in user-data.sh

    Follow deployment-steps.md step-by-step

    Test by accessing the ALB DNS name

    Document your process in GitHub

This complete setup gives you:

    ✅ Production-ready Node.js app

    ✅ Detailed deployment instructions

    ✅ Health checks for ALB

    ✅ Auto-scaling configuration

    ✅ Monitoring and troubleshooting guide