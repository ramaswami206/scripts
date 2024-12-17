#!/bin/bash

# Install Docker
echo "Installing Docker..."
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker

# Pull Jenkins image
echo "Pulling Jenkins image..."
sudo docker pull jenkins/jenkins:lts

# Run Jenkins container
echo "Running Jenkins container..."
sudo docker run -d -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home jenkins/jenkins:lts

# Get container ID
echo "Getting container ID..."
CONTAINER_ID=$(sudo docker ps -qf "ancestor=jenkins/jenkins:lts")

# Retrieve initial admin password
echo "Retrieving initial admin password..."
PASSWORD=$(sudo docker exec -it $CONTAINER_ID cat /var/jenkins_home/secrets/initialAdminPassword)

# Print initial admin password
echo "Initial admin password: $PASSWORD"

# Print Jenkins URL
echo "Jenkins URL: http://localhost:8080"

# Install Terraform
echo "Installing Terraform..."
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# Verify Terraform installation
echo "Verifying Terraform installation..."
terraform --version

# Install AWS CLI
echo "Installing AWS CLI..."
sudo yum install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify AWS CLI installation
echo "Verifying AWS CLI installation..."
aws --version

echo "Installation Complete: Docker, Jenkins, Terraform, and AWS CLI are ready!"
