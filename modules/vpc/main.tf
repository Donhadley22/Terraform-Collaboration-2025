# Create VPC 
resource "aws_vpc" "gp_vpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    tags = {
        Name =  "my-vpc"
    }
    lifecycle {
        create_before_destroy = false
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gp_igw" {
   vpc_id = aws_vpc.gp_vpc.id

   tags = {
    Name = "gp-igw"
   }

     lifecycle {
    create_before_destroy = false
  }
 }

# Create Elastic IP for NAT Gateway
resource "aws_eip" "gp_eip" {
  depends_on = [aws_internet_gateway.gp_igw]
  domain   = "vpc"

  tags = {
    Name = "elastic-ip" 
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "gp_nat_gw" {
    subnet_id = aws_subnet.gp_web_public_subnets[1].id
    allocation_id = aws_eip.gp_eip.id
   
    tags = {
      Name = "gp_nat-gw"
    }

  depends_on = [aws_internet_gateway.gp_igw]
}

data "aws_availability_zones" "avail_zone" {
}

# Create web tier public subnet
resource "aws_subnet" "gp_web_public_subnets" {
    count = var.web_pub_sub_count
   vpc_id = aws_vpc.gp_vpc.id
   cidr_block = "10.0.${1 + count.index}.0/24"
   availability_zone = data.aws_availability_zones.avail_zone.names[count.index]
   map_public_ip_on_launch = true

    tags = {
        Name = "web-subnet${count.index + 1}"
    }
}

# Create app tier private subnet
resource "aws_subnet" "gp_app_private_subnets" {
    count = var.private_sub_count
   vpc_id = aws_vpc.gp_vpc.id
   cidr_block = "10.0.${3 + count.index}.0/24"
   availability_zone = data.aws_availability_zones.avail_zone.names[count.index]
   map_public_ip_on_launch = false

    tags = {
        Name = "private-subnet${count.index + 1}"
    }
}

# Create db tier private subnet
resource "aws_subnet" "gp_db_private_subnets" {
    count = var.private_sub_count
   vpc_id = aws_vpc.gp_vpc.id
   cidr_block = "10.0.${5 + count.index}.0/24"
   availability_zone = data.aws_availability_zones.avail_zone.names[count.index]
   map_public_ip_on_launch = false

    tags = {
        Name = "db-subnet${count.index + 1}"
    }
}

# Create db subnet group
resource "aws_db_subnet_group" "gp_db_subnet_group" {
    count = var.db_subnet_group == true ? 1 : 0
    name       = "db-subnet-group"
 subnet_ids = aws_subnet.gp_db_private_subnets[*].id

  tags = {
    Name = "My DB subnet group"
  }
}

# Route table for public subnets
resource "aws_route_table" "gp_public_rt" {
   vpc_id = aws_vpc.gp_vpc.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gp_igw.id
   }

   tags = {
     Name = "public-rt"
   }
 }

# Route table for private subnet
 resource "aws_route_table" "gp_private_rt" {
  vpc_id = aws_vpc.gp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gp_nat_gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "gp_web_rt_asso" {
    count = var.web_pub_sub_count
    subnet_id = aws_subnet.gp_web_public_subnets.*.id[count.index]
    route_table_id = aws_route_table.gp_public_rt.id
}

resource "aws_route_table_association" "gp_app_rt_asso" {
    count = var.private_sub_count
    subnet_id = aws_subnet.gp_app_private_subnets.*.id[count.index]
    route_table_id = aws_route_table.gp_private_rt.id
}

resource "aws_route_table_association" "db_rt_asso_2" {
    count = var.private_sub_count
    subnet_id = aws_subnet.gp_db_private_subnets.*.id[count.index]
    route_table_id = aws_route_table.gp_private_rt.id
}

