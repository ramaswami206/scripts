provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  description = "Security group to allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instances" {
  count         = 4
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t2.medium"

  root_block_device {
    volume_size = 30
  }

  security_groups = [aws_security_group.allow_all.name]

  user_data = <<-EOF
    #!/bin/bash

    # Install Docker
    echo "Installing Docker..."
    sudo yum update -y
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker

    # Install Terraform
    echo "Installing Terraform..."
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform

    # Verify Terraform installation
    echo "Verifying Terraform installation..."
    terraform --version

    # Install AWS CLI
    echo "Installing AWS CLI..."
    sudo yum install -y unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    # Verify AWS CLI installation
    echo "Verifying AWS CLI installation..."
    aws --version

    # Install Git
    echo "Installing Git..."
    sudo yum install -y git

    # Verify Git installation
    echo "Verifying Git installation..."
    git --version

    # Set Docker Hub credentials and variables
    DOCKER_USERNAME="awsdora"
    REPO_NAME="jenkins-lts-custom"
    IMAGE_TAG="latest"

    # Build Docker image
    echo "Building Docker image..."
    docker build -t $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG .

    # Log in to Docker Hub
    echo "Logging in to Docker Hub..."
    echo "B@dri206" | docker login -u $DOCKER_USERNAME --password-stdin

    # Push Docker image to Docker Hub
    echo "Pushing Docker image to Docker Hub..."
    docker push $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG

    # Print success message
    echo "Docker image pushed successfully to Docker Hub as $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG"

    echo "Pulling Docker image from Docker Hub..."
    docker pull $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG

    # Run the Docker image
    echo "Running the pulled Docker image..."
    docker run -d -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home $DOCKER_USERNAME/$REPO_NAME:$IMAGE_TAG

    # Unlock Jenkins
    echo "Unlocking Jenkins..."
    docker exec -it $(docker ps -q -f ancestor=$DOCKER_USERNAME/$REPO_NAME) bash -c "echo 'jenkins' | /usr/local/bin/jenkins-cli login --username admin --password admin"
    docker exec -it $(docker ps -q -f ancestor=$DOCKER_USERNAME/$REPO_NAME) bash -c "/usr/local/bin/jenkins-cli install-plugin workflow-aggregator"
    docker exec -it $(docker ps -q -f ancestor=$DOCKER_USERNAME/$REPO_NAME) bash -c "/usr/local/bin/jenkins-cli install-plugin git"
    docker exec -it $(docker ps -q -f ancestor=$DOCKER_USERNAME/$REPO_NAME) bash -c "/usr/local/bin/jenkins-cli install-plugin docker-plugin"
    docker exec -it $(docker ps -q -f ancestor=$DOCKER_USERNAME/$REPO_NAME) bash -c "/usr/local/bin/jenkins-cli install-plugin kubernetes-plugin"
    docker exec -it $(docker ps -q -f ancestor=$DOCKER_USERNAME/$REPO_NAME) bash -c "/usr/local/bin/jenkins-cli install-plugin configuration-as-code"
    docker exec -it $(docker ps -q -f ancestor=$DOCKER_USERNAME/$REPO_NAME) bash -c "/usr/local/bin/jenkins-cli install-plugin job-dsl"
    docker exec -it $(docker ps -q -f ancestor=$DOCKER_USERNAME/$REPO
