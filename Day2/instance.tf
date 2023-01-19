resource "aws_security_group" "sec-group-apache2" {
  name        = "apache2-secgroup"
  description = "Security group for allowing http "
  vpc_id      = aws_vpc.terraform.id

 ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [ var.all-trafic-cidr ]

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all-trafic-cidr]
  }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.all-trafic-cidr]
  }
}

resource "aws_instance" "terraform-public-instance" {
  ami           = var.default-ami
  instance_type = var.default-instance-type
  subnet_id     = aws_subnet.main[0].id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.sec-group-apache2.id ]
  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  EOF

  tags = {
    Name = "terraform-public-instance"
  }
}

resource "aws_instance" "terraform-private-instance" {
  depends_on = [
    aws_nat_gateway.natGatway
  ]
  ami           = var.default-ami
  instance_type = var.default-instance-type
  subnet_id     = aws_subnet.main[1].id
  vpc_security_group_ids = [aws_security_group.sec-group-apache2.id ]
  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  EOF

  tags = {
    Name = "terraform-private-instance"
  }
}
