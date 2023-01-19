resource "aws_internet_gateway" "internetgatway" {
  vpc_id = aws_vpc.terraform.id

  tags = {
    Name = "Terraform internetgateway"
  }
}
