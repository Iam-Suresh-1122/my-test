#!/bin/bash

set -euo pipefail

# Update these values as needed
PROFILE="myprofile"
CIDR_BLOCK="10.0.0.0/16"
VPC_NAME="MyVPC"
SUBNET_CIDR="10.0.1.0/24"
SUBNET_NAME="MySubnet"
Password="suresh"

# Authenticate to AWS CLI
# Use aws configure if you have IAM credentials, or aws sso login for SSO profiles.
# Uncomment the appropriate line below.

# aws configure --profile "$PROFILE"
aws sso login --profile "$PROFILE"

# Create the VPC
VPC_ID=$(aws ec2 create-vpc \
  --profile "$PROFILE" \
  --cidr-block "$CIDR_BLOCK" \
  --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$VPC_NAME}]" \
  --query 'Vpc.VpcId' --output text)

# Enable DNS support and DNS hostnames
aws ec2 modify-vpc-attribute --profile "$PROFILE" --vpc-id "$VPC_ID" --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --profile "$PROFILE" --vpc-id "$VPC_ID" --enable-dns-hostnames "{\"Value\":true}"

echo "Created VPC: $VPC_ID"

echo "Creating subnet in VPC $VPC_ID"
SUBNET_ID=$(aws ec2 create-subnet \
  --profile "$PROFILE" \
  --vpc-id "$VPC_ID" \
  --cidr-block "$SUBNET_CIDR" \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$SUBNET_NAME}]" \
  --query 'Subnet.SubnetId' --output text)

echo "Created Subnet: $SUBNET_ID"

echo "VPC creation complete. VPC ID: $VPC_ID, Subnet ID: $SUBNET_ID"
