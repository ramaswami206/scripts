#!/bin/bash

# Diagnostic Information Collection
echo "=== SYSTEM INFORMATION ==="
echo "Hostname: $(hostname)"
echo "OS Version: $(cat /etc/os-release)"
echo "Kernel Version: $(uname -r)"

echo -e "\n=== JAVA INFORMATION ==="
java -version
javac -version

echo -e "\n=== JENKINS PACKAGE INFORMATION ==="
rpm -qa | grep jenkins
dnf list installed | grep jenkins

echo -e "\n=== JENKINS SERVICE LOGS ==="
journalctl -u jenkins --no-pager

echo -e "\n=== DETAILED JENKINS SERVICE STATUS ==="
systemctl status jenkins

echo -e "\n=== CHECKING JENKINS WAR FILE ==="
ls -l /usr/share/java/jenkins.war

echo -e "\n=== CHECKING JENKINS CONFIG ==="
cat /etc/sysconfig/jenkins 2>/dev/null

echo -e "\n=== PERMISSIONS CHECK ==="
ls -ld /var/lib/jenkins
ls -ld /var/cache/jenkins

echo -e "\n=== NETWORK PORT CHECK ==="
netstat -tuln | grep 8080

# Troubleshooting Steps
echo -e "\n=== ATTEMPTING MANUAL JENKINS STARTUP ==="
sudo -u jenkins java -jar /usr/share/java/jenkins.war --help

# Create a comprehensive repair script
cat << 'EOF' > /tmp/jenkins_repair.sh
#!/bin/bash

# Stop Jenkins service
systemctl stop jenkins

# Remove existing Jenkins cache
rm -rf /var/lib/jenkins/cache
rm -rf /var/cache/jenkins/war

# Recreate directories with correct permissions
mkdir -p /var/lib/jenkins
mkdir -p /var/cache/jenkins/war
chown -R jenkins:jenkins /var/lib/jenkins
chown -R jenkins:jenkins /var/cache/jenkins

# Reinstall Jenkins
dnf reinstall -y jenkins

# Restart and enable Jenkins
systemctl daemon-reload
systemctl restart jenkins
systemctl enable jenkins

# Check status
systemctl status jenkins
EOF

chmod +x /tmp/jenkins_repair.sh

echo -e "\n=== REPAIR SCRIPT CREATED AT /tmp/jenkins_repair.sh ==="
echo "Please review and run the script manually if needed."
