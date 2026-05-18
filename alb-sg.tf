resource "aws_security_group" "alb-sg" {
  description = "Allow HTTP ALB security group"
  name        = "alb-security-group"
  vpc_id = aws_vpc.my-vpc.id

  ingress {
    description = "Allow HTTP (80)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.public-cidr]
    protocol    = "-1"
  }

  tags = {
    Name = "alb-security-group"
    Env  = "dev"
  }
}