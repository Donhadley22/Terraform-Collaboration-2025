output "websg_sec_id" {
  value = aws_security_group.gp_web_sg.id
}

output "weblbsg_sec_id" {
  value = aws_security_group.gp_web_lb_sg.id
}

output "appsg_sec_id" {
  value = aws_security_group.gp_app_sg.id
}

output "applbsg_sec_id" {
  value = aws_security_group.gp_app_lb_sg.id
}

output "db_sec_id" {
  value = aws_security_group.gp_db_sg.id
}