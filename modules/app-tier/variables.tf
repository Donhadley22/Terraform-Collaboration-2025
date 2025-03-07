variable "gp_app_private_subnets" {}
variable "gp_app_lb_sg" {}
variable "gp_vpc_id" {}
variable "gp_app_sg" {}
variable "image_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "lbtg_port" {}
variable "lbtg_protocol" {}
variable "email" {}
variable "listener_port" {}
variable "listener_protocol" {}
# Compare this snippet from modules/app-tier/main.tf: