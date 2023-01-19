resource "aws_eip" "elastic-ip" {
 network_border_group = "us-east-1"
}

resource "aws_nat_gateway" "natGatway" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.main[0].id

  tags = {
    Name = "Terraform NAT"
  }

  depends_on = [
    aws_internet_gateway.internetgatway
    ]
}

resource "aws_route_table" "terraform-natgatway-route-table" {
  vpc_id = aws_vpc.terraform.id

  route {
    nat_gateway_id = aws_nat_gateway.natGatway.id
    cidr_block = var.all-trafic-cidr
 
  }

  tags = {
    Name = "terraform-routetable"
  }
}

resource "aws_route_table_association" "natgatway-subnet-association" {
  subnet_id      = aws_subnet.main[1].id
  route_table_id = aws_route_table.terraform-natgatway-route-table.id
}