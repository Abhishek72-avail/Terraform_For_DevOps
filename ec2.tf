# -----------------------
# Key Pair (for SSH login)
# -----------------------
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# -----------------------
# VPC & Security Group
# -----------------------
resource "aws_default_vpc" "default_vpc" {
  # This resource creates a default VPC in the specified region
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Allow SSH, HTTP, and custom port access"
  vpc_id      = aws_default_vpc.default_vpc.id

  # Inbound Rules
  ingress {
    description = "Allow SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP access from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow custom port 8000 access from anywhere"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------
# EC2 Instance
# -----------------------
resource "aws_instance" "my_instance" {
  ami                    = "ami-02521d90e7410d9f0" # Ubuntu AMI; update as needed for your region
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my_key.key_name
  security_groups        = [aws_security_group.my_sg.name]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "my-ec2-instance"
  }
}
