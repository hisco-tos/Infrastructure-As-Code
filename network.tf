#aws vpc resource
resource "aws_vpc" "terraform" {
  cidr_block       = "10.0.0.0/16"
  

  tags = {
    Name = "terraform_vpc"
  }
}

#internet gateway resource
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform.id
    tags = {
        Name = "terraform_igw"
    }
}





#public route table resource
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

#   route {
#     ipv6_cidr_block        = "::/0"
#     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
#   }

  tags = {
    Name = "terraform_rt"
  }
}



#private route table resource
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.terraform.id

route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id =  aws_internet_gateway.terraform_igw.id
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id =  aws_internet_gateway.terraform_igw.id
  }

#   route {
#     ipv6_cidr_block        = "::/0"
#     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
#   }

  tags = {
    Name = "private_rt"
  }
}







# elastic IP -2 

resource "aws_eip" "one" {
  tags = {
    Name = "nov25-eip-1"
  }
}

resource "aws_eip" "two" {
  tags = {
    Name = "nov25-eip-1"
  }
}






#public subnet resource 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet"
  }
}

#public subnet resource 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"

  tags = {
    Name = "public_subnet"
  }
}

#aws_rt association for public subnet 1
resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}   

#aws_rt association for public subnet 2
resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}   



#private subnet resource 1

# private subnets - 2

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.terraform.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private_subnet_1"
  }
}


resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.terraform.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
    tags = {
        Name = "private_subnet_2"
    }   
}

#aws_rt association for private subnet 1
resource "aws_route_table_association" "private_rt_assoc_1" {   
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

#aws_rt association for private subnet 2
resource "aws_route_table_association" "private_rt_assoc_2" {   
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}   



# Nat gateway
resource "aws_nat_gateway" "nat1" {
  # implict dependency on eip resource
  allocation_id = aws_eip.one.id
  subnet_id     = aws_subnet.public_subnet_1.id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform_igw]
}

resource "aws_nat_gateway" "nat2" {
  # implict dependency on eip resource
  allocation_id = aws_eip.two.id
  subnet_id     = aws_subnet.public_subnet_2.id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform_igw]

}






# database private subnets -2

resource "aws_subnet" "rds1" {
  vpc_id            = aws_vpc.terraform.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "terraform-db-subnet-1"
  }
}

resource "aws_subnet" "rds2" {
  vpc_id            = aws_vpc.terraform.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "terraform-db-subnet-2"
  }
}

