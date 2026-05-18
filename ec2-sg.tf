resource "aws_security_group" "ec2-sg" {
  description = "Allow HTTP traffic for EC2 instance"
  name        = "instance-security-group"
  vpc_id = aws_vpc.my-vpc.id
  
  ingress {
    description     = "Allow HTTP (80)"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.public-cidr]
    protocol    = "-1"
  }

  tags = {
    Name = "instance-security-group"
    Env  = "dev"
  }
}