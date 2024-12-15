#!/bin/bash

# Function to check command success
check_command_success() {
    if [ $? -ne 0 ]; then
        echo "Command failed. Exiting."
        exit 1
    fi

}

# Update the package manager
sudo yum update -y
check_command_success

# Install EPEL repository (required for some packages)
sudo amazon-linux-extras install epel -y
check_command_success

# Install Java (OpenJDK 11)
sudo amazon-linux-extras install java-openjdk11 -y
check_command_success

# Install Git
sudo yum install git -y
check_command_success

# Add Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo --no-check-certificate
check_command_success

# Import Jenkins repository key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
check_command_success

# Install Jenkins
sudo yum install jenkins -y
check_command_success

# Start Jenkins service
sudo systemctl start jenkins
check_command_success

# Enable Jenkins to start on boot
sudo systemctl enable jenkins
check_command_success

# Check Jenkins status
sudo systemctl status jenkins

echo "Jenkins installation and setup completed successfully."
echo "Access Jenkins at http://<Your_Public_IP>:8080/"
echo "Retrieve the initial admin password with: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
