#!/bin/bash
source red.conf

REGION="us-east-1"
AMI_ID="ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI para us-east-1
INSTANCE_TYPE="t2.micro"
KEY_NAME="mi-clave-ec2"         # Ya debes tener esta key creada en AWS

# Crear Security Group
SG_ID=$(aws ec2 create-security-group \
  --group-name mi-sg \
  --description "SG para EC2" \
  --vpc-id $VPC_ID \
  --region $REGION \
  --query "GroupId" \
  --output text)

# Permitir SSH
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0 \
  --region $REGION

# Lanzar EC2
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SG_ID \
  --subnet-id $SUBNET_ID \
  --associate-public-ip-address \
  --region $REGION \
  --query "Instances[0].InstanceId" \
  --output text)

# Guardar ID
echo "INSTANCE_ID=$INSTANCE_ID" > ec2.conf
echo "SG_ID=$SG_ID" >> ec2.conf

echo "✅ EC2 creada con ID $INSTANCE_ID"
