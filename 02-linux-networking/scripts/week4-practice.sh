#!/bin/bash
# Week 4: Linux Networking & AWS Integration Practice

echo "=========================================="
echo "Week 4: Linux Networking & AWS Integration"
echo "=========================================="

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_header "Day 22: Linux Network Configuration"
echo "Current network configuration:"
echo "1. IP Addresses:"
ip addr show 2>/dev/null | grep -E "inet (192|10|172)" || hostname -I
echo ""
echo "2. Routing table:"
ip route show 2>/dev/null | head -5
echo ""
echo "3. Network interfaces:"
ls /sys/class/net/ 2>/dev/null | xargs -I {} echo "- {}"

print_header "Day 23: SSH Key Authentication"
echo "SSH Key Configuration:"
if [ -f ~/.ssh/id_rsa.pub ]; then
    echo -e "${GREEN}✓ SSH key exists${NC}"
    echo "Public key fingerprint:"
    ssh-keygen -lf ~/.ssh/id_rsa.pub
else
    echo -e "${YELLOW}⚠ No SSH key found. Generate with:${NC}"
    echo "  ssh-keygen -t rsa -b 4096 -C 'your-email@example.com'"
fi

echo ""
echo "SSH config file example (~/.ssh/config):"
cat << 'EOF'
Host myserver
    HostName server.example.com
    User ubuntu
    Port 22
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
EOF

print_header "Day 24: Firewall Configuration"
echo "Checking firewall status:"
which ufw >/dev/null 2>&1
if [ $? -eq 0 ]; then
    sudo ufw status 2>/dev/null || echo "UFW exists but status requires sudo"
else
    echo -e "${YELLOW}UFW not installed. Install with:${NC}"
    echo "  sudo apt install ufw  # Debian/Ubuntu"
    echo "  sudo yum install ufw  # RHEL/CentOS"
fi

echo ""
echo "Common firewall rules:"
echo "  sudo ufw allow ssh"
echo "  sudo ufw allow http"
echo "  sudo ufw allow https"
echo "  sudo ufw allow from 192.168.1.0/24"

print_header "Day 25: AWS VPC Fundamentals"
echo "AWS VPC Concepts:"
cat << 'EOF'
VPC Components:
1. VPC (Virtual Private Cloud) - Your isolated network
2. Subnets - Segments of VPC IP range
   - Public subnet: Has route to Internet Gateway
   - Private subnet: No direct internet access
3. Route Tables - Define traffic routes
4. Internet Gateway (IGW) - Connect VPC to internet
5. NAT Gateway - Outbound internet for private subnets

CIDR Block Examples:
- 10.0.0.0/16 (65,536 IPs)
- 192.168.0.0/24 (256 IPs)
- 172.16.0.0/20 (4,096 IPs)
EOF

print_header "Day 26: Security Groups vs NACLs"
cat << 'EOF'
Security Groups (Instance Level):
• Stateful (return traffic automatically allowed)
• Allow rules only (no explicit deny)
• Evaluated first
• Associated with instances

NACLs (Subnet Level):
• Stateless (specify both inbound/outbound)
• Allow AND deny rules
• Evaluated after Security Groups
• Associated with subnets
• Rule numbers matter (lower = higher priority)

Example Security Group Rules:
Inbound:
- SSH (22) from your IP only
- HTTP (80) from anywhere
- HTTPS (443) from anywhere

Example NACL Rules:
Inbound:
100 Allow SSH from 192.168.1.0/24
200 Allow HTTP from 0.0.0.0/0
*   Deny all

Outbound:
100 Allow all to 0.0.0.0/0
EOF

print_header "Day 27: Route Tables & Internet Gateway"
echo "Sample VPC Route Table Configuration:"
cat << 'EOF'
Public Subnet Route Table:
Destination        Target
10.0.0.0/16        local
0.0.0.0/0          igw-12345 (Internet Gateway)

Private Subnet Route Table:
Destination        Target
10.0.0.0/16        local
0.0.0.0/0          nat-12345 (NAT Gateway)
EOF

print_header "Day 28: Complete EC2 Deployment Script"
cat > ec2-deployment.sh << 'EOF'
#!/bin/bash
# AWS EC2 Linux Server Deployment Script
# Requires: AWS CLI configured, appropriate IAM permissions

# Configuration
VPC_CIDR="10.0.0.0/16"
PUBLIC_SUBNET_CIDR="10.0.1.0/24"
PRIVATE_SUBNET_CIDR="10.0.2.0/24"
REGION="us-east-1"
KEY_NAME="my-key-pair"
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 LTS

echo "=== AWS EC2 Deployment ==="

# 1. Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block $VPC_CIDR \
    --region $REGION \
    --query 'Vpc.VpcId' \
    --output text)

# 2. Create Subnets
echo "Creating Public Subnet..."
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $PUBLIC_SUBNET_CIDR \
    --region $REGION \
    --query 'Subnet.SubnetId' \
    --output text)

echo "Creating Private Subnet..."
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $PRIVATE_SUBNET_CIDR \
    --region $REGION \
    --query 'Subnet.SubnetId' \
    --output text)

# 3. Create Internet Gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
    --region $REGION \
    --query 'InternetGateway.InternetGatewayId' \
    --output text)

aws ec2 attach-internet-gateway \
    --vpc-id $VPC_ID \
    --internet-gateway-id $IGW_ID \
    --region $REGION

# 4. Create Route Table
echo "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --region $REGION \
    --query 'RouteTable.RouteTableId' \
    --output text)

aws ec2 create-route \
    --route-table-id $ROUTE_TABLE_ID \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $IGW_ID \
    --region $REGION

aws ec2 associate-route-table \
    --subnet-id $PUBLIC_SUBNET_ID \
    --route-table-id $ROUTE_TABLE_ID \
    --region $REGION

# 5. Create Security Group
echo "Creating Security Group..."
SG_ID=$(aws ec2 create-security-group \
    --group-name "WebServerSG" \
    --description "Security group for web server" \
    --vpc-id $VPC_ID \
    --region $REGION \
    --query 'GroupId' \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \
    --region $REGION

aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 \
    --region $REGION

# 6. Launch EC2 Instance
echo "Launching EC2 Instance..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SG_ID \
    --subnet-id $PUBLIC_SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WebServer}]' \
    --region $REGION \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "=== Deployment Complete ==="
echo "VPC ID: $VPC_ID"
echo "Public Subnet: $PUBLIC_SUBNET_ID"
echo "Instance ID: $INSTANCE_ID"
echo ""
echo "To connect:"
echo "1. Wait 2 minutes for instance to initialize"
echo "2. Get public IP:"
echo "   aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text"
echo "3. SSH: ssh -i ~/.ssh/$KEY_NAME.pem ubuntu@<public-ip>"
EOF

chmod +x ec2-deployment.sh
echo "Created deployment script: ec2-deployment.sh"
echo -e "${YELLOW}Note: Requires AWS CLI configured with appropriate permissions${NC}"

print_header "Week 4 Cheatsheet"
cat > ~/aws-linux-week4-cheatsheet.md << 'EOF'
# Week 4 Cheatsheet: Linux Networking & AWS

## Linux Network Commands
- `ip addr show` - Show IP addresses
- `ip route show` - Show routing table
- `ss -tulpn` - Show listening ports
- `netstat -tulpn` - Alternative to ss
- `systemctl restart networking` - Restart network
- `journalctl -u systemd-networkd` - Network service logs

## SSH Configuration
Generate key: `ssh-keygen -t rsa -b 4096 -C "email"`
Copy key: `ssh-copy-id user@host`
Test connection: `ssh -T git@github.com`
Config file: `~/.ssh/config`

## Firewall (UFW)
- `sudo ufw enable` - Enable firewall
- `sudo ufw disable` - Disable firewall
- `sudo ufw status` - Check status
- `sudo ufw allow ssh` - Allow SSH
- `sudo ufw allow 80/tcp` - Allow HTTP
- `sudo ufw allow from 192.168.1.0/24` - Allow from subnet
- `sudo ufw delete rule` - Delete rule

## AWS VPC CLI Commands
Create VPC: `aws ec2 create-vpc --cidr-block 10.0.0.0/16`
Create subnet: `aws ec2 create-subnet --vpc-id vpc-123 --cidr-block 10.0.1.0/24`
Create IGW: `aws ec2 create-internet-gateway`
Attach IGW: `aws ec2 attach-internet-gateway --vpc-id vpc-123 --internet-gateway-id igw-123`
Create route table: `aws ec2 create-route-table --vpc-id vpc-123`
Add route: `aws ec2 create-route --route-table-id rtb-123 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-123`

## Security Groups
Create SG: `aws ec2 create-security-group --group-name MySG --description "Description" --vpc-id vpc-123`
Add rule: `aws ec2 authorize-security-group-ingress --group-id sg-123 --protocol tcp --port 22 --cidr 0.0.0.0/0`
List SGs: `aws ec2 describe-security-groups`

## EC2 Management
Launch instance: `aws ec2 run-instances --image-id ami-123 --instance-type t2.micro --key-name mykey`
List instances: `aws ec2 describe-instances`
Start instance: `aws ec2 start-instances --instance-ids i-123`
Stop instance: `aws ec2 stop-instances --instance-ids i-123`
Terminate: `aws ec2 terminate-instances --instance-ids i-123`

## AWS Cost-Saving Tips
1. Use t2.micro/t3.micro for testing (free tier eligible)
2. Always tag resources: `--tag-specifications`
3. Clean up resources after practice
4. Use CloudWatch alarms for billing
5. Enable Cost Explorer for monitoring

## Best Practices
1. Use private subnets for databases
2. Implement least privilege in Security Groups
3. Use SSH keys instead of passwords
4. Enable detailed billing reports
5. Create separate VPCs for dev/test/prod
EOF

echo -e "\n${GREEN}Cheatsheet saved to: ~/aws-linux-week4-cheatsheet.md${NC}"
echo -e "\n${GREEN}Month 2 practice materials created successfully!${NC}"
echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Run each week's practice script"
echo "2. Complete the projects mentioned"
echo "3. Update your GitHub learning journal"
echo "4. Take notes on challenges and solutions"