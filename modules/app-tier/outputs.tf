output "gp_app_asg" {
  value = aws_autoscaling_group.gp_app_asg
}

output "gp_lb_dns" {
  value = aws_lb.gp_app_lb.dns_name
}

output "gp_lb_endpoint" {
  value = aws_lb.gp_app_lb.dns_name
}

output "lb_target_group_name" {
  value = aws_lb_target_group.gp_app_lbtg.name
}

output "app_sns_name" {
    value = aws_sns_topic.gp_app_sns.name
}

output "lb_tg" {
  value = aws_lb_target_group.gp_app_lbtg.arn
}