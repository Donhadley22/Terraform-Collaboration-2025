resource "aws_vpc" "group_project_vpc" {
  cidr_block = var.Cidr_block
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

resource "aws_subnet" "gp_subnet" {
  vpc_id     = aws_vpc.group_project_vpc.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = var.gp_sbnet
  }
}

resource "aws_route_table" "gp_rt" {
  vpc_id = aws_vpc.group_project_vpc.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.gp_gw.id
  }

  tags = {
    Name = var.rt_name
  }
}

