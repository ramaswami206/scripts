#!/bin/bash

# Update the system
sudo yum update -y

# Install Java (OpenJDK 11)
sudo amazon-linux-extras install java-openjdk11 -y

# Add Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import the Jenkins GPG key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Install Jenkins
sudo yum install jenkins -y

# Start the Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Check the status of Jenkins service
sudo systemctl status jenkins

# Output the initial admin password
echo "Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
