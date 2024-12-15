#!/bin/bash

# Ensure script is run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Update system packages
dnf update -y

# Install Java 11 Corretto
dnf install -y java-11-amazon-corretto-devel

# Set JAVA_HOME
mkdir -p /etc/profile.d
cat << EOF > /etc/profile.d/java.sh
export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
export PATH=$PATH:$JAVA_HOME/bin
EOF
chmod +x /etc/profile.d/java.sh
source /etc/profile.d/java.sh

# Verify Java installation
java -version

# Install wget and add repositories
dnf install -y wget

# Import Jenkins repository key
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Create Jenkins repository file
cat << EOF > /etc/yum.repos.d/jenkins.repo
[jenkins-stable]
name=Jenkins Stable
baseurl=https://pkg.jenkins.io/redhat-stable
gpgcheck=1
gpgkey=https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
enabled=1
EOF

# Clean and update package cache
dnf clean all
dnf makecache

# Install Jenkins
dnf install -y jenkins

# Configure network security for Jenkins
# Amazon Linux 2023 uses nftables, so we'll use that
nft add rule inet filter input tcp dport 8080 accept

# Start and enable Jenkins service
systemctl daemon-reload
systemctl start jenkins
systemctl enable jenkins

# Check Jenkins service status
systemctl status jenkins

# Attempt to find initial admin password
JENKINS_PASS=$(find /var/lib/jenkins -name "initialAdminPassword" -exec cat {} \; 2>/dev/null)

# Output results
echo "Jenkins Installation Complete!"
if [ -n "$JENKINS_PASS" ]; then
    echo "Initial Admin Password: $JENKINS_PASS"
else
    echo "Could not automatically retrieve initial admin password."
    echo "Please check /var/lib/jenkins/secrets/initialAdminPassword manually."
fi

# Additional troubleshooting information
echo "Java Version:"
java -version

echo "Jenkins Service Status:"
systemctl status jenkins
