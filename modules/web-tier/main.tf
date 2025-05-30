# Webserver template
resource "aws_launch_template" "gp_web_lt" {
  name_prefix   = "Web-lt"
  image_id      = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.gp_web_sg]
  key_name = var.key_name
  description = "Launch template for webserver"
  user_data = filebase64("userdata-web.sh")

    tags = {
      Name = "Web Launch Template"
    }
}

resource "aws_autoscaling_group" "gp_web_asg" {
  name = "Web-autoscaling-group"
  vpc_zone_identifier = var.gp_web_public_subnets
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  health_check_grace_period = 200
  health_check_type = "ELB"

target_group_arns =[aws_lb_target_group.gp_web_lbtg.arn]

  launch_template {
    id      = aws_launch_template.gp_web_lt.id
    version = "$Latest"
  }

 tag { 
    key                 = "Name"
    value               = "gp-web-asg-instance"
    propagate_at_launch = true
}
}

# Creating an autoscaling policy
resource "aws_autoscaling_attachment" "gp_web_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.gp_web_asg.name
  lb_target_group_arn    = aws_lb_target_group.gp_web_lbtg.arn
}

# Creating An SNS Topic. 
resource "aws_sns_topic" "gp_web_sns" {
 name         = "web-asg-sns"
 display_name = "App Autoscaling"
} 

# Creating Autoscaling Notifications
resource "aws_autoscaling_notification" "gp_web_asg_notify" {
 group_names = ["${aws_autoscaling_group.gp_web_asg.name}"]
 topic_arn     = "${aws_sns_topic.gp_web_sns.arn}"
 notifications  = [
   "autoscaling:EC2_INSTANCE_LAUNCH",
   "autoscaling:EC2_INSTANCE_TERMINATE",
   "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
   "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
 ]
}

# Creating sns topic for webmail
resource "aws_sns_topic_subscription" "web_email_sub" {
  topic_arn = aws_sns_topic.gp_web_sns.arn
  protocol  = "email"
  endpoint  = var.email
}


# Creating Web-tier load balancer
 resource "aws_lb" "gp_web_lb" {
    name       = "web-laodbalancing"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.gp_web_lb_sg]
    subnets            = var.gp_web_public_subnets

  enable_deletion_protection = false

depends_on = [ 
  aws_autoscaling_group.gp_web_asg
 ]


  tags = {
    Name = "Web-elb"
  } 
}

# Create target group for web-tier load balancer
resource "aws_lb_target_group" "gp_web_lbtg" {
  name        = "web-lb-target-group"
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
    Name = "Web loadbalancer target group"
  }
}

# Creating web load balancer listener
resource "aws_lb_listener" "gp_weblb_listener" {
  load_balancer_arn = aws_lb.gp_web_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gp_web_lbtg.arn
  }
}


