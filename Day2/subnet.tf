resource "aws_subnet" "main" {
  count = length(var.subnet-cidr)
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.subnet-cidr[count.index]

  tags = {
    Name = "Terraform subnet ${count.index}"
  }
}