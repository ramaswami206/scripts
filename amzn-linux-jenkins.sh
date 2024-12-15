#!/bin/bash

# Update system and install essential packages
sudo yum update -y
sudo yum install -y wget curl unzip java-11-openjdk-devel

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk' | sudo tee -a /etc/profile.d/java.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/java.sh
sudo chmod +x /etc/profile.d/java.sh
source /etc/profile.d/java.sh

# Remove any existing Jenkins repositories
sudo rm -f /etc/yum.repos.d/jenkins.repo

# Import Jenkins repository key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Add Jenkins repository (using latest stable version)
sudo bash -c 'cat << EOF > /etc/yum.repos.d/jenkins.repo
[jenkins-stable]
name=Jenkins-stable
baseurl=https://pkg.jenkins.io/redhat-stable
gpgcheck=1
gpgkey=https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
enabled=1
EOF'

# Clean yum cache
sudo yum clean all
sudo yum makecache

# Install Jenkins
sudo yum install -y jenkins

# Configure network security for Jenkins
# For Amazon Linux 2, use iptables instead of firewall-cmd
sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
sudo service iptables save

# Start and enable Jenkins service
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Verify Jenkins service status
sudo systemctl status jenkins

# Print initial admin password
echo "Jenkins Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
