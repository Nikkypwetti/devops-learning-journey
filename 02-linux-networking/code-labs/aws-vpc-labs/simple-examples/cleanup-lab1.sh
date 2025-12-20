#!/bin/bash

# ============================================
# Cleanup Script for Lab 1
# ============================================

echo "🧹 Cleaning up Lab 1 resources..."
echo "=================================="

# Configuration (should match lab1-create-vpc.sh)
REGION="us-east-1"
KEY_NAME="my-key-pair"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

cleanup_resource() {
    echo -n "Cleaning $1... "
    if aws $2 --region $REGION 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
}

# Find and terminate the instance
echo "Looking for instances to terminate..."
INSTANCE_IDS=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=WebServer" \
    --query 'Reservations[].Instances[].InstanceId' \
    --output text \
    --region $REGION)

if [ -n "$INSTANCE_IDS" ]; then
    echo "Terminating instances: $INSTANCE_IDS"
    aws ec2 terminate-instances \
        --instance-ids $INSTANCE_IDS \
        --region $REGION
    
    # Wait for termination
    echo "Waiting for instances to terminate..."
    aws ec2 wait instance-terminated \
        --instance-ids $INSTANCE_IDS \
        --region $REGION
    echo -e "${GREEN}Instances terminated${NC}"
else
    echo "No instances found to terminate"
fi

# Find and delete security groups
echo "Looking for security groups to delete..."
SG_IDS=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=WebServer-SG" \
    --query 'SecurityGroups[].GroupId' \
    --output text \
    --region $REGION)

for SG_ID in $SG_IDS; do
    echo "Deleting security group: $SG_ID"
    aws ec2 delete-security-group \
        --group-id $SG_ID \
        --region $REGION 2>/dev/null
done

# Find and delete subnets
echo "Looking for subnets to delete..."
SUBNET_IDS=$(aws ec2 describe-subnets \
    --filters "Name=cidr-block,Values=10.0.1.0/24" \
    --query 'Subnets[].SubnetId' \
    --output text \
    --region $REGION)

for SUBNET_ID in $SUBNET_IDS; do
    echo "Deleting subnet: $SUBNET_ID"
    aws ec2 delete-subnet \
        --subnet-id $SUBNET_ID \
        --region $REGION 2>/dev/null
done

# Find and detach/delete internet gateways
echo "Looking for internet gateways to delete..."
VPC_IDS=$(aws ec2 describe-vpcs \
    --filters "Name=cidr-block,Values=10.0.0.0/16" \
    --query 'Vpcs[].VpcId' \
    --output text \
    --region $REGION)

for VPC_ID in $VPC_IDS; do
    # Find IGW attached to VPC
    IGW_ID=$(aws ec2 describe-internet-gateways \
        --filters "Name=attachment.vpc-id,Values=$VPC_ID" \
        --query 'InternetGateways[].InternetGatewayId' \
        --output text \
        --region $REGION)
    
    if [ -n "$IGW_ID" ]; then
        echo "Detaching and deleting IGW: $IGW_ID"
        aws ec2 detach-internet-gateway \
            --internet-gateway-id $IGW_ID \
            --vpc-id $VPC_ID \
            --region $REGION 2>/dev/null
        
        aws ec2 delete-internet-gateway \
            --internet-gateway-id $IGW_ID \
            --region $REGION 2>/dev/null
    fi
    
    # Delete route tables (except main)
    ROUTE_TABLE_IDS=$(aws ec2 describe-route-tables \
        --filters "Name=vpc-id,Values=$VPC_ID" \
        --query 'RouteTables[?Associations[0].Main!=`true`].RouteTableId' \
        --output text \
        --region $REGION)
    
    for RT_ID in $ROUTE_TABLE_IDS; do
        echo "Deleting route table: $RT_ID"
        aws ec2 delete-route-table \
            --route-table-id $RT_ID \
            --region $REGION 2>/dev/null
    done
    
    # Delete VPC
    echo "Deleting VPC: $VPC_ID"
    aws ec2 delete-vpc \
        --vpc-id $VPC_ID \
        --region $REGION 2>/dev/null
done

echo -e "\n${GREEN}✅ Cleanup completed!${NC}"
echo ""
echo "📋 Resources cleaned up:"
echo "   - EC2 Instances"
echo "   - Security Groups"
echo "   - Subnets"
echo "   - Internet Gateways"
echo "   - Route Tables"
echo "   - VPC"
echo ""
echo "💡 Check AWS Console to ensure all resources are deleted."