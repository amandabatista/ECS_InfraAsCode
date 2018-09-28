/*
# ALB Security Group
resource "aws_security_group" "tw_alb_sg1" {
  name        = "tw-teste-alb-sg1"
  description = "ALB Security Group"
  vpc_id      = "${aws_vpc.twVPC1.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "tw-teste-alb-sg1"
  }
}
*/

# ECS Service Security Group
resource "aws_security_group" "tw_ecs_service_sg" {
  vpc_id      = "vpc-05ce30447a6b0b03b"  #"${aws_vpc.twVPC.id}"
  name        = "tw-teste-ecs-service-sg"
  description = "Allow egress from container"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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