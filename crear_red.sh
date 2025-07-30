#!/bin/bash

# Variables
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
REGION="us-east-1"
TAG_NAME="mi-red"

# Crear VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query "Vpc.VpcId" --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$TAG_NAME

# Crear subred
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --region $REGION --query "Subnet.SubnetId" --output text)

# Crear Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --query "InternetGateway.InternetGatewayId" --output text)
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID

# Crear tabla de rutas
RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION --query "RouteTable.RouteTableId" --output text)
aws ec2 create-route --route-table-id $RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
aws ec2 associate-route-table --subnet-id $SUBNET_ID --route-table-id $RT_ID

# Hacer pública la subred
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID --map-public-ip-on-launch

# Guardar IDs
echo "VPC_ID=$VPC_ID" > red.conf
echo "SUBNET_ID=$SUBNET_ID" >> red.conf
echo "IGW_ID=$IGW_ID" >> red.conf
echo "RT_ID=$RT_ID" >> red.conf

echo "✅ Infraestructura de red creada."
