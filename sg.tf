#creating a resource for terraform security group
resource "aws_security_group" "terra_sg" {
  name        = "terraform_sg"
  description = "Allow inbound traffic on port 80 and 22"
  vpc_id = aws_vpc.terraform.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# security group for ALB

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow Postgres traffic"
  vpc_id      = aws_vpc.terraform.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]

  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/24"]

  }
}

# security group for RDS

# security group for rds
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow Postgres traffic"
  vpc_id      = aws_vpc.terraform.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    #security_groups = [aws_security_group.ecs_sg.id]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/24"]

  }
}