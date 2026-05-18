# Deployind EC2 instance in the first private subnet
resource "aws_instance" "instance-1" {
  ami               = data.aws_ami.ami.id
  instance_type     = var.instance-type
  subnet_id = aws_subnet.private-subnet-1.id
  key_name          = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  user_data = file("userdata.sh")
  tags = {
    Name = "instance-1"
    Env  = "dev"
  }
}

# Deployind EC2 instance in the second private subnet
resource "aws_instance" "instance-2" {
  ami               = data.aws_ami.ami.id
  instance_type     = var.instance-type
  subnet_id = aws_subnet.private-subnet-2.id
  key_name          = aws_key_pair.keypair.key_name
  user_data = file("userdata.sh")
  tags = {
    Name = "instance-2"
    Env  = "dev"
  }
}