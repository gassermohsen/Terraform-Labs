
resource "aws_route_table" "terraform-route-table" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = var.all-trafic-cidr
    gateway_id = aws_internet_gateway.internetgatway.id
  }

  tags = {
    Name = "terraform-routetable"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.main[0].id
  route_table_id = aws_route_table.terraform-route-table.id
}
