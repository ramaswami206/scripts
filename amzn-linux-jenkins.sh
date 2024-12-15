#!/bin/bash

# Update package list
sudo yum update -y

# Install Java
sudo amazon-linux-extras install java-openjdk11 -y

# Verify Java installation
java -version

# Add Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# Install Jenkins
sudo yum install jenkins -y

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins service to start at boot
sudo systemctl enable jenkins

# Configure firewall to allow Jenkins port (8080)
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# Print Jenkins initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
