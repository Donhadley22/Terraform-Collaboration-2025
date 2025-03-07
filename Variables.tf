variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "image_name" {}

variable "my_public_key" {}

variable "ip" {
  type = string
}

variable "gp_app_sg" {}
variable "gp_app_lb_sg" {}
variable "gp_app_public_subnets" {}
variable "gp_db_sg" {}
variable "gp_db_subnet_group" {}