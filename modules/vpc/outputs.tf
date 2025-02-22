output "vpc_id" {
  value = aws_vpc.gp_vpc
}

output "web_public_subnets" {
  value = aws_subnet.gp_web_public_subnets.*.id
}

output "app_private_subnets" {
  value = aws_subnet.gp_app_private_subnets.*.id
}

output "db_private_subnets" {
  value = aws_subnet.gp_db_private_subnets.*.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.gp_db_subnet_group.*.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.gp_db_subnet_group.*.name
}