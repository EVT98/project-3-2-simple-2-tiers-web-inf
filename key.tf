# Generation of the private SSH key
resource "tls_private_key" "private-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Creation of the AWS key pair
resource "aws_key_pair" "keypair" {
  key_name   = "project3key"
  public_key = tls_private_key.private-key.public_key_openssh
}

# Local storage of the private PEM key
resource "local_file" "key" {
  content  = tls_private_key.private-key.private_key_pem
  filename = "${aws_key_pair.keypair.key_name}.pem"
}

