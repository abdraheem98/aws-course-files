resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "pub-sub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone.id

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "pri-sub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.27.0/24"
  availability_zone = var.availability_zone_pri.id

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "My-igw"
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_rt"
  }
}

resource "aws_route_table_association" "pub-subnet-rt-assc" {
  subnet_id      = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_eip" "nateip" {
  domain   = "vpc"
}


resource "aws_nat_gateway" "my-nat-gw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = aws_subnet.pub-sub.id

  tags = {
    Name = "gw NAT"
  }

}

resource "aws_route_table" "pri-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-nat-gw.id
  }

  tags = {
    Name = "Private_rt"
  }
}


resource "aws_route_table_association" "pri-subnet-rt-assc" {
  subnet_id      = aws_subnet.pri-sub.id
  route_table_id = aws_route_table.pri-rt.id
}


resource "aws_instance" "pub-ec2" {
  ami           = "ami-076fe60835f136dc9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.pub-sub.id
  associate_public_ip_address = true

  
  tags = {
    Name = "Public-instance"
  }
}

resource "aws_instance" "pri-ec2" {
  ami           = "ami-076fe60835f136dc9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.pri-sub.id
  associate_public_ip_address = false

  
  tags = {
    Name = "Private subnet"
  }
}


