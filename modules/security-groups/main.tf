# Web LoadBalancer Security Group
resource "aws_security_group" "gp_web_lb_sg" {
    vpc_id = var.gp_vpc_id
    description = "Allow traffic from the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.ip]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "gp_web_lb_sg"
    }
}

# Web Instance Security Group
resource "aws_security_group" "gp_web_sg" {
    vpc_id = var.gp_vpc_id
    description = "Allow traffic from web loadbalancer and ssh"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups =  [aws_security_group.gp_web_lb_sg.id]
    }

 ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
    }
        tags = {
          Name = "gp-web-sg"
        }
}

# App LoadBalancer Security Group
resource "aws_security_group" "gp_app_lb_sg" {
    vpc_id = var.gp_vpc_id
    description = "Allow traffic from web sg"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups =  [aws_security_group.gp_web_sg.id]  
    } 

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
       Name = "gp-app-elb-sg"
    }
}
# App Instance Security Group
resource "aws_security_group" "gp_app_sg" {
    vpc_id = var.gp_vpc_id
    description = "Allow traffic from app loadbalancer and ssh from web instance"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.gp_web_sg.id]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.gp_app_lb_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

        tags = {
            Name = "gp-app-sg"
        }
}
# Database Security Group
 resource "aws_security_group" "gp_db_sg" {
   vpc_id = var.gp_vpc_id
   description = "Allow traffic from app instance"

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.gp_app_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "gp_db-sg"
    }
 }

