#VPC

resource "aws_vpc" "Jenkins_VPC2" {
  cidr_block = "172.0.0.0/16"
  tags = {
    Name = "Jenkis_VPC"
  }

}

#Subnet

resource "aws_subnet" "Jenkins_Sub2" {
  vpc_id            = aws_vpc.Jenkins_VPC2.id
  cidr_block        = "172.0.1.0/24"
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "Pub-Subnet"
  }

}

# Internetgateway

resource "aws_internet_gateway" "Jen_IGW" {
  vpc_id = aws_vpc.Jenkins_VPC2.id
  tags = {
    Name = "Jenkins_IGW"
  }

}

# RouteTable

resource "aws_route_table" "RTA2" {
  vpc_id = aws_vpc.Jenkins_VPC2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Jen_IGW.id
  }

}

# Associate Route Table

resource "aws_route_table_association" "RTA2" {
  subnet_id      = aws_subnet.Jenkins_Sub2.id
  route_table_id = aws_route_table.RTA2.id

}

#Security Group

resource "aws_security_group" "sg1a" {
  name        = "webserver"
  description = "allow traffic for webserver"
  vpc_id      = aws_vpc.Jenkins_VPC2.id

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow traffic"
  }
}

resource "aws_instance" "jenkis" {
  ami                    = var.amis[var.region]
  count                  = 1
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.Jenkins_Sub2.id
  vpc_security_group_ids = [aws_security_group.sg1a.id]
  tags = {
    "Name" = "Spinned up Jenkins"
  }

  associate_public_ip_address = true
}
