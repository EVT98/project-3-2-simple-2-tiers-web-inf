# Creation of an ALB target group to route HTTP traffic to backend resources within the VPC
resource "aws_lb_target_group" "tg" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 6
    unhealthy_threshold = 3
  }
}

# Deployment of a public Application Load Balancer across two public subnets to distribute incoming HTTP traffic
resource "aws_lb" "alb" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  enable_deletion_protection = false

  tags = {
    Env = "dev"
  }
}

resource "aws_lb_target_group_attachment" "tg-att-1" {
  target_id = aws_instance.instance-1.id
  target_group_arn = aws_lb_target_group.tg.arn
  port = 80
}

resource "aws_lb_target_group_attachment" "tg-att-2" {
  target_id = aws_instance.instance-2.id
  target_group_arn = aws_lb_target_group.tg.arn
  port = 80
}



# Deployment of a public Application Load Balancer across two public subnets to distribute incoming HTTP traffic
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}