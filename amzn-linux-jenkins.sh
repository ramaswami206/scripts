#!/bin/bash

# Ensure script is run with root/sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo or as root" 
   exit 1
fi

# Update system packages
echo "Updating system packages..."
yum update -y

# Install required dependencies
echo "Installing required dependencies..."
yum install -y wget curl tar git

# Install Terraform
echo "Installing Terraform..."
# Get the latest Terraform version
TERRAFORM_VERSION=$(curl -s https://checkpoint.hashicorp.com/v1/check/terraform | grep -o '"latest_version":"[^"]*' | cut -d'"' -f4)
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Docker
echo "Installing Docker..."
# Remove any existing Docker installations
yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# Install Docker dependencies
yum install -y yum-utils device-mapper-persistent-data lvm2

# Add Docker repository
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Add current user to docker group (optional, allows running docker without sudo)
if [[ -n "$SUDO_USER" ]]; then
    usermod -aG docker $SUDO_USER
fi

# Install Java (required for Jenkins)
echo "Installing Java..."
amazon-linux-extras install java-openjdk11 -y

# Pull and run Jenkins container
echo "Pulling and running Jenkins container..."
docker pull jenkins/jenkins:lts
docker run -d -p 8080:8080 -p 50000:50000 \
    -v jenkins_home:/var/jenkins_home \
    --name jenkins \
    -e JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
    jenkins/jenkins:lts

# Additional security for Docker socket permissions
chmod 666 /var/run/docker.sock

# Print completion message
echo "Installation complete!"
echo "Terraform, Git, Docker, and Jenkins have been installed."
echo "Jenkins is running on http://localhost:8080"
echo "Initial admin password can be found by running: docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"

# Verify installations
echo "Verifying installations..."
terraform version
docker --version
git --version
