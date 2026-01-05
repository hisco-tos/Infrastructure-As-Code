
resource "aws_instance" "first_instance" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-instance"
  }
}

