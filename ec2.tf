
resource "aws_instance" "first_instance" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-instance"
  }
}



#s3 bucket resource

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-terraform-bucket-123456"

  tags = {
    Name        = "MyTerraformBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}