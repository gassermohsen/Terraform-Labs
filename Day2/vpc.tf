resource "aws_vpc" "terraform" {
  cidr_block = var.vpc-cidr
  tags = {
    "Name" = "Terraform"
  }
}