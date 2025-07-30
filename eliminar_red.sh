#!/bin/bash
source red.conf

REGION="us-east-1"

# Desasociar y eliminar tabla de rutas
RTB_ASSOC_ID=$(aws ec2 describe-route-tables --route-table-ids $RT_ID --region $REGION \
  --query "RouteTables[0].Associations[0].RouteTableAssociationId" --output text)
aws ec2 disassociate-route-table --association-id $RTB_ASSOC_ID
aws ec2 delete-route-table --route-table-id $RT_ID

# Desadjuntar y eliminar Internet Gateway
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID

# Eliminar Subnet y VPC
aws ec2 delete-subnet --subnet-id $SUBNET_ID
aws ec2 delete-vpc --vpc-id $VPC_ID

rm red.conf

echo "🗑️ Infraestructura de red eliminada."
