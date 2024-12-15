#!/bin/bash

# Update the system
echo "Updating the system..."
sudo yum update -y

# Install EPEL repository
echo "Installing EPEL repository..."
sudo amazon-linux-extras install epel -y

# Install Java (OpenJDK 11 or Amazon Corretto)
echo "Installing Java (OpenJDK 11)..."
sudo yum install java-11-amazon-corretto -y

# Add Jenkins repository
echo "Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import the Jenkins GPG key
echo "Importing Jenkins GPG key..."
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Clean up any cached packages to avoid GPG check issues
echo "Cleaning up cached packages..."
sudo yum clean all

# Install Jenkins using dnf to avoid GPG issues
echo "Installing Jenkins..."
if ! sudo dnf install jenkins -y; then
    echo "Error: Failed to install Jenkins. Please check the repository and GPG key."
    exit 1
fi

# Check if the Jenkins service file exists
if [ ! -f /usr/lib/systemd/system/jenkins.service ]; then
    echo "Error: Jenkins service file not found. Please check the installation."
    exit 1
fi

# Start the Jenkins service
echo "Starting Jenkins service..."
if ! sudo systemctl start jenkins; then
    echo "Error: Failed to start Jenkins service."
    exit 1
fi

# Enable Jenkins to start on boot
echo "Enabling Jenkins to start on boot..."
sudo systemctl enable jenkins

# Check the status of Jenkins service
echo "Checking the status of Jenkins service..."
sudo systemctl status jenkins

# Output the initial admin password
echo "Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "Jenkins installation completed. Access it at http://<your_instance_public_ip>:8080"
