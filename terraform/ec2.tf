resource "tls_private_key" "mykey" {
  algorithm = "RSA"
}

resource "aws_key_pair" "aws_key" {
  key_name   = "web-key-ec2"
  public_key = tls_private_key.mykey.public_key_openssh
}

resource "null_resource" "update_permissions" {
  provisioner "local-exec" {
    command = <<EOT
      echo '${tls_private_key.mykey.private_key_openssh}' > ./web-key-ec2.pem
      chmod 400 ./web-key-ec2.pem
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}


resource "aws_instance" "myec2" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  key_name = "web-key-ec2"
  subnet_id = aws_subnet.subnet-1.id
  vpc_security_group_ids = [aws_security_group.sa-sg.id]
  tags = {
    Name = "Terraform-ec2"
  }
}