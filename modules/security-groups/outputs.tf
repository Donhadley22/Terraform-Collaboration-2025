output "gp_web_sg" {
  value = aws_security_group.gp_web_sg.id
}

output "gp_web_lb_sg" {
  value = aws_security_group.gp_web_lb_sg.id
}

output "gp_app_sg" {
  value = aws_security_group.gp_app_sg.id
}

output "gp_app_lb_sg" {
  value = aws_security_group.gp_app_lb_sg.id
}

output "gp_db_sg" {
  value = aws_security_group.gp_db_sg.id
}

