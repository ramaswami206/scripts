#!/bin/bash

# Update the system
echo "Updating the system..."
sudo yum update -y

# Install EPEL repository
echo "Installing EPEL repository..."
sudo amazon-linux-extras install epel -y

# Install Java (OpenJDK 11)
echo "Installing Java (OpenJDK 11)..."
sudo yum install java-1.8.0-openjdk-devel -y

# Add Jenkins repository
echo "Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo

# Import the Jenkins GPG key
echo "Importing Jenkins GPG key..."
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# Install Jenkins
echo "Installing Jenkins..."
sudo yum install jenkins -y

# Check if the Jenkins service file exists
if [ -f /usr/lib/systemd/system/jenkins.service ]; then
    echo "Jenkins service file found."
else
    echo "Error: Jenkins service file not found. Please check the installation."
    exit 1
fi

# Start the Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins

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
