resource "aws_vpc" "group_project_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.VPC_Name
  }
}

resource "aws_internet_gateway" "gp_gw" {
  vpc_id = aws_vpc.group_project_vpc.id

  tags = {
    Name = var.gp_gw
  }
}

