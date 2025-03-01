resource "aws_db_instance" "gp_mysql" {
  engine = var.engine
  engine_version  = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.db_storage
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = var.gp_db_subnet_group_name
  multi_az = var.multi_az
  vpc_security_group_ids = [var.gp_db_sg]
  identifier             = var.db_identifier
  skip_final_snapshot = var.skip_final_snapshot

  tags = {
    Name = "mysql-db"
  }  
}
