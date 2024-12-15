#!/bin/bash

# Update system
sudo dnf update -y

# Install Java 11
sudo dnf install -y java-11-amazon-corretto-devel

# Set JAVA_HOME for Corretto Java 11
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto' | sudo tee -a /etc/profile.d/java.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/java.sh
sudo chmod +x /etc/profile.d/java.sh
source /etc/profile.d/java.sh

# Import Jenkins repository key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Add Jenkins repository
sudo bash -c 'cat << EOF > /etc/yum.repos.d/jenkins.repo
[jenkins-stable]
name=Jenkins-stable
baseurl=https://pkg.jenkins.io/redhat-stable
gpgcheck=1
gpgkey=https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
enabled=1
EOF'

# Clean and update package cache
sudo dnf clean all
sudo dnf makecache

# Install Jenkins
sudo dnf install -y jenkins

# Configure network security for Jenkins
sudo firewall-offline-cmd --add-port=8080/tcp
sudo systemctl restart firewalld

# Start and enable Jenkins service
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Verify Jenkins service status
sudo systemctl status jenkins

# Print initial admin password
echo "Jenkins Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
