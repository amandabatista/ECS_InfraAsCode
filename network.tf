/*
# Define a vpc
resource "aws_vpc" "twVPC1" {
  cidr_block = "${var.project_network_cidr}"  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "twVPC1"
  }
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "twIG1" {
  vpc_id = "${aws_vpc.twVPC1.id}"
  tags {
    Name = "twIG1"
  }
}

# Public subnet AZ1
resource "aws_subnet" "twPublicSubnet1" {
  vpc_id = "${aws_vpc.twVPC1.id}"
  cidr_block = "${var.project_public_01_cidr}"
  availability_zone = "${var.availability_zone1}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "twPublicSubnet1"
  }
}

# Public subnet AZ2
resource "aws_subnet" "twPublicSubnet2" {
  vpc_id = "${aws_vpc.twVPC1.id}"
  cidr_block = "${var.project_public_02_cidr}"
  availability_zone = "${var.availability_zone2}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "twPublicSubnet2"
  }
}
/*

/*
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

# Elastic IP - Precisa???
resource "aws_eip" "vpc_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.twIG"]
}
*/