#1 Create VPC
resource "aws_vpc" "nat-vpc" {
  cidr_block       = "25.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    Name = "nat-vpc"
    Environment = "devops"
  }
}

#2 Create IGW
resource "aws_internet_gateway" "nat-igw" {
  vpc_id = aws_vpc.nat-vpc.id

  tags = {
    Name = "nat-igw"
    Environment = "devops"
  }
}

#3 Create Public Route table
resource "aws_route_table" "nat-pubrt" {
  vpc_id = aws_vpc.nat-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat-igw.id
  }

#  route {
#    ipv6_cidr_block        = "::/0"
#   egress_only_gateway_id = aws_egress_only_internet_gateway.nat-igw.id
#  }

  tags = {
    Name = "nat-pubrt"
    Environment = "devops"
  }
}

#4 Create a Pblic Subnet in London region
resource "aws_subnet" "nat-pubsn-2a" {
  vpc_id     = aws_vpc.nat-vpc.id
  availability_zone = "eu-west-2a"
  cidr_block = "25.0.0.0/24"

  tags = {
    Name = "nat-pubsn-2a"
    Environment = "devops"
  }
}

#5 Associate the Subnet with RT
resource "aws_route_table_association" "nat-a" {
  subnet_id      = aws_subnet.nat-pubsn-2a.id
  route_table_id = aws_route_table.nat-pubrt.id
}

#6 Create a Security Group
resource "aws_security_group" "nat-pubsg" {
  name        = "nat-pubsg"
  description = "Access to SSH and RDP from a single IP address & HTTPS from anywhere"
  vpc_id      = aws_vpc.nat-vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["198.167.100.20/32"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["198.167.100.20/32"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "nat-pubsg"
    Environment = "devops"
  }
}

#7 Create a network interface with an IP in the sybnet created in step 4
resource "aws_network_interface" "nat-pubni-2a" {
  subnet_id       = aws_subnet.nat-pubsn-2a.id
  private_ips     = ["25.0.0.4"]
  security_groups = [aws_security_group.nat-pubsg.id]

#  attachment {
#   instance     = aws_instance.test.id
#   device_index = 1
# }
}

#8 Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "nat-eip1" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.nat-eni-2a.id
  associate_with_private_ip = "25.0.0.4"

  tags = {
    Name = "nat-eip1"
    Environment = "devops"
  }

  depends_on = [aws_internet_gateway.gw]
}

#Launch an EC2 instance
resource "aws_instance" "nat-server1" {
  ami           = "ami-08447c25f2e9dc66c" # eu-west-2,ubuntu 20.04
  instance_type = "t2.micro"
   key_name = "London KP"


  network_interface {
    network_interface_id = aws_network_interface.nat-eni-2a.id
    device_index         = 0
  }

  root_block_device {
    volume_size = 12
  }

   tags = {
    Name = "nat-server1"
    Environment = "devops"
  }
}


#1 next you will need to validate
  #run >terraform validate
  #response > Success! The configuration is valid.

#2 display the configurations you are about to make
  #run > terraform plan

#3 Create infrastructure
  #run >terraform apply
