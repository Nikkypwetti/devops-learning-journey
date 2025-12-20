#!/bin/bash

# ============================================
# LAB 1: Create Your First VPC
# ============================================
# This script creates a simple VPC with:
# - 1 VPC
# - 1 Public Subnet
# - 1 Internet Gateway
# - 1 Route Table
# - 1 Security Group
# - 1 EC2 Instance
# ============================================

echo "🚀 Starting Lab 1: Create Your First VPC"
echo "========================================="

# Configuration
VPC_NAME="MyFirstVPC"
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
REGION="us-east-1"
INSTANCE_TYPE="t2.micro"
KEY_NAME="my-key-pair"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_step() {
    echo -e "\n${YELLOW}Step $1: $2${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Step 1: Create VPC
print_step "1" "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block $VPC_CIDR \
    --region $REGION \
    --query 'Vpc.VpcId' \
    --output text 2>/dev/null)

if [ -z "$VPC_ID" ]; then
    print_error "Failed to create VPC"
    exit 1
fi

print_success "VPC created: $VPC_ID"

# Add name tag
aws ec2 create-tags \
    --resources $VPC_ID \
    --tags Key=Name,Value=$VPC_NAME \
    --region $REGION

# Step 2: Create Subnet
print_step "2" "Creating Public Subnet..."
SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $SUBNET_CIDR \
    --availability-zone ${REGION}a \
    --region $REGION \
    --query 'Subnet.SubnetId' \
    --output text)

print_success "Subnet created: $SUBNET_ID"

# Step 3: Create Internet Gateway
print_step "3" "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
    --region $REGION \
    --query 'InternetGateway.InternetGatewayId' \
    --output text)

print_success "Internet Gateway created: $IGW_ID"

# Attach IGW to VPC
aws ec2 attach-internet-gateway \
    --vpc-id $VPC_ID \
    --internet-gateway-id $IGW_ID \
    --region $REGION

print_success "Internet Gateway attached to VPC"

# Step 4: Create Route Table
print_step "4" "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --region $REGION \
    --query 'RouteTable.RouteTableId' \
    --output text)

print_success "Route Table created: $ROUTE_TABLE_ID"

# Add route to internet
aws ec2 create-route \
    --route-table-id $ROUTE_TABLE_ID \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $IGW_ID \
    --region $REGION

print_success "Route added: 0.0.0.0/0 -> Internet Gateway"

# Associate route table with subnet
aws ec2 associate-route-table \
    --subnet-id $SUBNET_ID \
    --route-table-id $ROUTE_TABLE_ID \
    --region $REGION

print_success "Route table associated with subnet"

# Step 5: Create Security Group
print_step "5" "Creating Security Group..."
SG_ID=$(aws ec2 create-security-group \
    --group-name "WebServer-SG" \
    --description "Security group for web server" \
    --vpc-id $VPC_ID \
    --region $REGION \
    --query 'GroupId' \
    --output text)

print_success "Security Group created: $SG_ID"

# Add rules to Security Group
# Allow SSH from anywhere (for learning - in production, restrict this!)
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \
    --region $REGION

# Allow HTTP from anywhere
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 \
    --region $REGION

# Allow HTTPS from anywhere
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0 \
    --region $REGION

print_success "Security Group rules added (SSH:22, HTTP:80, HTTPS:443)"

# Step 6: Launch EC2 Instance
print_step "6" "Launching EC2 Instance..."
# Get latest Ubuntu AMI
AMI_ID=$(aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
    --query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
    --output text \
    --region $REGION)

print_success "Using AMI: $AMI_ID"

# User data script to install web server
USER_DATA=$(base64 << 'EOF'
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>Hello from AWS VPC Lab!</h1>" > /var/www/html/index.html
EOF
)

# Launch instance
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SG_ID \
    --subnet-id $SUBNET_ID \
    --user-data "$USER_DATA" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WebServer}]' \
    --region $REGION \
    --query 'Instances[0].InstanceId' \
    --output text)

print_success "Instance launched: $INSTANCE_ID"

# Wait for instance to be running
print_step "7" "Waiting for instance to be ready..."
aws ec2 wait instance-running \
    --instance-ids $INSTANCE_ID \
    --region $REGION

# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text \
    --region $REGION)

# Get instance state
INSTANCE_STATE=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].State.Name' \
    --output text \
    --region $REGION)

# ============================================
# SUMMARY
# ============================================
echo -e "\n${GREEN}🎉 Lab 1 Completed Successfully!${NC}"
echo "========================================="
echo "VPC Resources Created:"
echo "----------------------"
echo "VPC ID:          $VPC_ID"
echo "Subnet ID:       $SUBNET_ID"
echo "Internet Gateway: $IGW_ID"
echo "Route Table:     $ROUTE_TABLE_ID"
echo "Security Group:  $SG_ID"
echo "EC2 Instance:    $INSTANCE_ID"
echo "Public IP:       $PUBLIC_IP"
echo "Instance State:  $INSTANCE_STATE"
echo ""
echo "🌐 Access your web server:"
echo "   URL: http://$PUBLIC_IP"
echo ""
echo "🔗 Connect via SSH:"
echo "   ssh -i ~/.ssh/$KEY_NAME.pem ubuntu@$PUBLIC_IP"
echo ""
echo "💡 Next Steps:"
echo "   1. Visit http://$PUBLIC_IP in your browser"
echo "   2. Try to SSH into the instance"
echo "   3. Explore the VPC in AWS Console"
echo ""
echo "🧹 Clean up (to avoid charges):"
echo "   ./cleanup-lab1.sh"