provider "aws" {
  region = "us-east-1" # Adjust the region as needed
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

resource "aws_instance" "example" {
  count         = 4 # Create 4 instances
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t2.medium"

  root_block_device {
    volume_size = 30 # Size in GB
  }

  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "example-instance-${count.index + 1}"
  }
}
