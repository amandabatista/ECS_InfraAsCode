# ALB Security Group
resource "aws_security_group" "tw_alb_sg" {
  name        = "tw-teste-alb-sg"
  description = "ALB Security Group"
  vpc_id      = "${aws_vpc.twVPC.id}"

  ingress {
    from_port   = "3000"
    to_port     = "3000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "tw-teste-alb-sg"
  }
}

# ECS Service Security Group
resource "aws_security_group" "tw_ecs_service_sg" {
  vpc_id      = "${aws_vpc.twVPC.id}"
  name        = "tw-teste-ecs-service-sg"
  description = "Allow egress from container"

  ingress {
    protocol        = "tcp"
    from_port       = "3000"
    to_port         = "3000"
    security_groups = ["${aws_security_group.tw_alb_sg.id}"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "tw-teste-ecs-service-sg"
  }
}