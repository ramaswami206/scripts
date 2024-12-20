#!/bin/bash

# Install Dockers
echo "Installing Docker..."
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker


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

# Set Docker Hub credentials and variables
DOCKER_USERNAME="awsdora"
REPO_NAME="jenkins-lts-custom"
IMAGE_TAG="latest"

# Build Docker image
echo "Building Docker image..."
docker build -t $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG .

# Log in to Docker Hub
echo "Logging in to Docker Hub..."
echo "B@dri206" | docker login -u $DOCKER_USERNAME --password-stdin

# Push Docker image to Docker Hub
echo "Pushing Docker image to Docker Hub..."
docker push $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG

# Print success message
echo "Docker image pushed successfully to Docker Hub as $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG"

echo "Installation Complete: Docker, Jenkins, Terraform, AWS CLI are ready, and Docker image is pushed to Docker Hub."
echo "Pulling Docker image from Docker Hub..."
docker pull $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG

# Run the Docker image
echo "Running the pulled Docker image..."
docker run -d -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG
