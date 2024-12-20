# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create a security group that allows all incoming and outgoing traffic
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow all incoming and outgoing traffic"

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

# Create 3 EC2 instances
resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-01816d07b1128cd2d" # Replace with your desired AMI
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.example.id]
  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }
  tags = {
    Name = "example-ec2-${count.index}"
  }
}
