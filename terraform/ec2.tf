resource "tls_private_key" "mykey" {
  algorithm = "RSA"
}

resource "aws_key_pair" "aws_key" {
  key_name   = "web-key-ec2"
  public_key = tls_private_key.mykey.public_key_openssh
}

resource "aws_ssm_parameter" "ec2_private_key" {
  name        = "capstone/project1/ec2_private_key"
  description = "Private key of ec2 instance"
  type        = "SecureString"
  value       = tls_private_key.mykey.private_key_openssh
}

resource "aws_ssm_parameter" "ec2_public_key" {
  name        = "capstone/project1/ec2_public_key"
  description = "Public key of ec2 instance"
  type        = "SecureString"
  value       = tls_private_key.mykey.public_key_openssh
}


resource "aws_instance" "myec2" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  key_name = aws_key_pair.aws_key.key_name
  subnet_id = aws_subnet.subnet-1.id
  vpc_security_group_ids = [aws_security_group.sa-sg.id]
  tags = {
    Name = "Terraform-ec2"
  }
}