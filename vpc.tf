# Deployment of the main VPC that will serve as the base network for the infrastructure
resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "my-terraform-vpc"
    Env  = "dev"
    Team = "DevOps"
  }
}

# Deployment of the Internet Gateway to enable Internet connectivity for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
}

# Deployment of the first public subnet in the first Availability Zone
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = var.AZ1
  cidr_block              = var.cidr-subnet-1
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
    Env  = "dev"
  }
}

# Deployment of the first second public subnet in the first Availability Zone
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = var.AZ2
  cidr_block              = var.cidr-subnet-2
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
    Env  = "dev"
  }
}

# Deployment of the first private subnet in the first Availability Zone
resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = var.AZ1
  cidr_block              = var.cidr-subnet-3
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-1"
    Env  = "dev"
  }
}

# Deployment of the first second private subnet in the first Availability Zone
resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = var.AZ2
  cidr_block              = var.cidr-subnet-4
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-2"
    Env  = "dev"
  }
}

# Allocation of an Elastic IP address to provide a static public IPv4 address for AWS resources
resource "aws_eip" "eip" {

}

# Deployment of a NAT Gateway in the public subnet to allow private resources to access the Internet
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet-1.id
}

# Creation of a public route table with a default route to the Internet Gateway for Internet access
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = var.public-cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform-public-route-table"
  }
}


# Creation of a private route table with a route through the NAT Gateway to allow private subnets to access the Internet
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = var.public-cidr
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "terraform-public-route-table"
  }

}

# Association of the first public subnet with the public route table to enable Internet access
resource "aws_route_table_association" "public-rta-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

# Association of the second public subnet with the public route table to enable Internet access
resource "aws_route_table_association" "public-rta-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

# Association of the first private subnet with the private route table to route outbound Internet traffic through the NAT Gateway
resource "aws_route_table_association" "private-rta-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}


# Association of the second private subnet with the private route table to route outbound Internet traffic through the NAT Gateway
resource "aws_route_table_association" "private-rta-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}