resource "aws_key_pair" "gp_tf_keypair" {
  key_name   = "tf-keypair"
  public_key = file(var.my_public_key)
}



module "web-tier" {
  source               = "./modules/web-tier"
  image_id             = var.ami_image
  instance_type        = "t2.micro"
  key_name             = "tf-keypair"
  gp_web_public_subnets = module.vpc.gp_web_public_subnets
  email                = "donhadleygirlandchika@gmail.com"
  gp_web_lb_sg         = module.security-groups.gp_web_lb_sg
  lbtg_port            = 80
  lbtg_protocol        = "HTTP"
  gp_vpc_id            = module.vpc.gp_vpc_id
  gp_web_sg            = module.security-groups.gp_web_sg
  listener_port        = 80
  listener_protocol    = "HTTP"
}

module "app-tier" {
  source                 = "./modules/app-tier"
  image_id               = var.ami_image
  instance_type          = "t2.micro"
  key_name               = "tf-keypair"
  gp_app_private_subnets = module.vpc.gp_app_private_subnets
  email                  = "donhadleygirlandchika@gmail.com"
  gp_app_lb_sg           = module.security-groups.gp_app_lb_sg
  lbtg_port              = 80
  lbtg_protocol          = "HTTP"
  gp_vpc_id              = module.vpc.gp_vpc_id
  gp_app_sg              = module.security-groups.gp_app_sg
  listener_port          = 80
  listener_protocol      = "HTTP"
}

module "db-tier" {
  source               = "./modules/db-tier"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "rdsmysql"
  db_password          = var.db_password
  db_username          = var.db_username
  db_identifier        = "db-tier"
  db_storage           = 10
  gp_db_sg                = module.security-groups.gp_db_sg
  gp_db_subnet_group_name = module.vpc.gp_db_subnet_group_name
  multi_az             = true
  skip_final_snapshot  = true
}

module "vpc" {
  source            = "./modules/vpc"
  cidr_block        = "10.0.0.0/16"
  web_pub_sub_count = 2
  private_sub_count = 2
  db_subnet_group   = true
  availability_zone = "us-east-1a"
  azs               = 2
}

module "security-groups" {
  source = "./modules/security-groups"
  gp_vpc_id = module.vpc.gp_vpc_id
  ip     = var.ip
}