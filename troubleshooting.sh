#!/bin/bash

# Check system package manager
echo "Checking package manager and installing dependencies..."
sudo yum update -y
sudo yum install -y epel-release

# Install required dependencies
sudo yum install -y java-11-openjdk-devel wget

# Import Jenkins repository key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Add Jenkins repository for Amazon Linux 2
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Clean yum cache
sudo yum clean all

# Try installing Jenkins
sudo yum install -y jenkins

# Troubleshooting steps
echo "Checking Jenkins installation..."
rpm -qa | grep jenkins

# Verify Java installation
java -version

# Detailed service checks
echo "Checking service status..."
sudo systemctl list-unit-files | grep jenkins
sudo systemctl status jenkins

# Alternative installation method
echo "Alternative installation method..."
sudo yum install -y https://mirrors.jenkins.io/pkg/redhat-stable/jenkins-2.440.1-1.noarch.rpm

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check service status again
sudo systemctl status jenkins

# Firewall configuration
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

echo "Troubleshooting complete. Check the output above for any specific errors."
