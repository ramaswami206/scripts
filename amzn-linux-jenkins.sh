#!/bin/bash

# Update the system
sudo yum update -y

# Install required dependencies
sudo yum install -y wget curl unzip

# Install Git
sudo yum install -y git

# Install Java (OpenJDK 11)
sudo yum install -y java-11-openjdk-devel

# Set JAVA_HOME environment variable
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk' | sudo tee -a /etc/profile.d/java.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/java.sh
sudo chmod +x /etc/profile.d/java.sh
source /etc/profile.d/java.sh

# Import Jenkins repository key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Add Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Install Jenkins
sudo yum install -y jenkins

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Open Jenkins port (default 8080) on firewall
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Install additional development tools
sudo yum groupinstall -y "Development Tools"

# Print initial admin password
echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Optional: Install Docker (uncomment if needed)
# sudo yum install -y docker
# sudo service docker start
# sudo usermod -a -G docker ec2-user
# sudo usermod -a -G docker jenkins

echo "Installation complete! Access Jenkins at http://your-server-ip:8080"
