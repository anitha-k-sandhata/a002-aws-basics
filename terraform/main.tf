module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name

  vpc_cidr = "10.0.0.0/16"

  public_subnet_1_cidr = "10.0.1.0/24"
  public_subnet_2_cidr = "10.0.2.0/24"

  private_subnet_1_cidr = "10.0.11.0/24"
  private_subnet_2_cidr = "10.0.12.0/24"

  availability_zone_1 = "ap-south-1a"
  availability_zone_2 = "ap-south-1b"
}

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web_1" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.public_subnet_1_id
  vpc_security_group_ids = [module.security_groups.ec2_sg_id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install nginx -y
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Web Server 1</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "${var.project_name}-web-1"
  }
}

resource "aws_instance" "web_2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.public_subnet_2_id
  vpc_security_group_ids = [module.security_groups.ec2_sg_id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install nginx -y
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Web Server 2</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "${var.project_name}-web-2"
  }
}

resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [module.security_groups.alb_sg_id]

  subnets = [
    module.vpc.public_subnet_1_id,
    module.vpc.public_subnet_2_id
  ]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "web_1" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_2" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_2.id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

module "waf" {
  source = "./modules/waf"

  project_name = var.project_name
  alb_arn      = aws_lb.main.arn
}
