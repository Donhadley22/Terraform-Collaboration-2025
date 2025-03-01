output "web_asg" {
  value = aws_autoscaling_group.gp_web_asg
}

output "lb_dns" {
  value = aws_lb.gp_web_lb.dns_name
}

output "lb_endpoint" {
  value = aws_lb.gp_web_lb.dns_name
}

output "lb_target_group_name" {
  value = aws_lb_target_group.gp_web_lbtg.name
}

output "web_sns_name" {
    value = aws_sns_topic.gp_web_sns.name
}