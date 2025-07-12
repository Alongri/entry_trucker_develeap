#!/bin/bash

# Update package list and install unzip
apt-get update -y
apt-get install -y unzip

# Install Docker
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list and install Docker
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable Docker service
systemctl enable docker
systemctl start docker

# Allow the 'ubuntu' user to run Docker without sudo
usermod -aG docker ubuntu

# Notify that the setup is complete
echo "Setup complete: unzip and Docker installed. Docker is accessible without sudo."

# Install AWS CLI (Version 2)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

echo "AWS CLI installed and ready to use."

# --- Pull image from AWS ECR ---

# Set environment variables (customize these)
AWS_REGION="ap-south-1"
ECR_IMAGE="884394270539.dkr.ecr.ap-south-1.amazonaws.com/development/entry-trucker:v1.0.1"

# Authenticate Docker to ECR
/usr/local/bin/aws ecr get-login-password --region $AWS_REGION \
  | docker login --username AWS --password-stdin 884394270539.dkr.ecr.ap-south-1.amazonaws.com

# Pull the image
docker pull $ECR_IMAGE

echo "Pulled ECR image: $ECR_IMAGE"
