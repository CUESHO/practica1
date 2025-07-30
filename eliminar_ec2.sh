#!/bin/bash
source ec2.conf

REGION="us-east-1"

# Terminar EC2
aws ec2 terminate-instances --instance-ids $INSTANCE_ID --region $REGION
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID --region $REGION

# Eliminar Security Group
aws ec2 delete-security-group --group-id $SG_ID --region $REGION

rm ec2.conf

echo "🗑️ EC2 y SG eliminados."
