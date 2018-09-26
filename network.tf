# Define a vpc
resource "aws_vpc" "twVPC" {
  cidr_block = "${var.project_network_cidr}"  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "tw-teste-vpc"
  }
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "twIG" {
  vpc_id = "${aws_vpc.twVPC.id}"
  tags {
    Name = "tw-teste-InternetGateway"
  }
}

# Public subnet AZ1
resource "aws_subnet" "twPublicSubnet1" {
  vpc_id = "${aws_vpc.twVPC.id}"
  cidr_block = "${var.project_public_01_cidr}"
  availability_zone = "${var.availability_zone1}"
  tags {
    Name = "tw-teste-publicSubnet1"
  }
}

# Public subnet AZ2
resource "aws_subnet" "twPublicSubnet2" {
  vpc_id = "${aws_vpc.twVPC.id}"
  cidr_block = "${var.project_public_02_cidr}"
  availability_zone = "${var.availability_zone2}"
  tags {
    Name = "tw-teste-publicSubnet2"
  }
}

# Routing table for public subnet
resource "aws_route_table" "twPublicRT" {
  vpc_id = "${aws_vpc.twVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.twIG.id}"
  }
  tags {
    Name = "tw-teste-PublicRT"
  }
}

# Associate the routing table to public subnets
resource "aws_route_table_association" "tw-web-public-rt1" {
  subnet_id = "${aws_subnet.twPublicSubnet1.id}"
  route_table_id = "${aws_route_table.twPublicRT.id}"
}

resource "aws_route_table_association" "tw-web-public-rt2" {
  subnet_id = "${aws_subnet.twPublicSubnet2.id}"
  route_table_id = "${aws_route_table.twPublicRT.id}"
}

# Create a NAT gateway with an Elastic to get internet connectivity
resource "aws_eip" "vpc_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.twIG"]
}