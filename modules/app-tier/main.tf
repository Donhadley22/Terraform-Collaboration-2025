# This file contains the configuration for the app-tier module.
# create a launch template for the app server
resource "aws_launch_template" "gp_app_lt" {
  name_prefix   = "App-lt"
  image_id      = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.gp_app_sg]
  key_name = var.key_name
  description = "Launch template for app server"
  user_data = filebase64("userdata-app.sh")

    tags = {
      Name = "GP App Launch Template"
    }
}

# create an auto scaling group for the app server
resource "aws_autoscaling_group" "gp_app_asg" {
  name = "App-autoscaling-group"
  vpc_zone_identifier = var.gp_app_private_subnets
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  health_check_grace_period = 200
  health_check_type = "ELB"

target_group_arns =[aws_lb_target_group.gp_app_lbtg.arn]

  launch_template {
    id      = aws_launch_template.gp_app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "gp-app-asg-instance"
    propagate_at_launch = true
}

}

resource "aws_autoscaling_attachment" "gp_app_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.gp_app_asg.name
  lb_target_group_arn    = aws_lb_target_group.gp_app_lbtg.arn
}

resource "aws_sns_topic" "gp_app_sns" {
 name         = "app-asg-sns"
 display_name = "App Autoscaling"
} 

resource "aws_autoscaling_notification" "gp_app_asg_notify" {
 group_names = ["${aws_autoscaling_group.gp_app_asg.name}"]
 topic_arn     = "${aws_sns_topic.gp_app_sns.arn}"
 notifications  = [
   "autoscaling:EC2_INSTANCE_LAUNCH",
   "autoscaling:EC2_INSTANCE_TERMINATE",
   "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
   "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
 ]
}

resource "aws_sns_topic_subscription" "gp_app_email_sub" {
  topic_arn = aws_sns_topic.gp_app_sns.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_lb" "gp_app_lb" {
    name       = "app-laodbalancing"
    internal           = true
    load_balancer_type = "application"
    security_groups    = [var.gp_app_lb_sg]  
    subnets            = var.gp_app_private_subnets

  enable_deletion_protection = false

depends_on = [ 
  aws_autoscaling_group.gp_app_asg,
 ]


  tags = {
    Name = "gp-App-elb"
  } 
}

resource "aws_lb_target_group" "gp_app_lbtg" {
  name        = "gp-app-lb-target-group"
  target_type = "instance"
  port        = var.lbtg_port
  protocol    = var.lbtg_protocol
  vpc_id      = var.gp_vpc_id

health_check {
  path = "/"
  interval = 30
  timeout = 10
  healthy_threshold = 2
  unhealthy_threshold = 2
}
lifecycle {
  create_before_destroy = true
}
  tags = {
    Name = "Gp-App loadbalancer target group"
  }
}

resource "aws_lb_listener" "gp_applb_listener" {
  load_balancer_arn = aws_lb.gp_app_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gp_app_lbtg.arn
  }
}
