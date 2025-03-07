output "gp_vpc_id" {
  value = aws_vpc.gp_vpc.id
  }

output "gp_web_public_subnets" {
  value = aws_subnet.gp_web_public_subnets[*].id
}

output "name" {
  value = aws_subnet.gp_web_public_subnets[*].tags.Name
  
}


output "gp_app_private_subnets" {
  value = aws_subnet.gp_app_private_subnets[*].id  # ✅ Ensure this exists
}

output "gp_db_subnet_group_name" {
  value = aws_db_subnet_group.gp_db_subnet_group[0].name  # ✅ Ensure correct indexing
}
