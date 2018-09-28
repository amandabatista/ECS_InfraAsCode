#Define application load balancer
resource "aws_alb" "tw_teste_alb1" {
  name            = "tw-teste-alb1"
  subnets         = ["subnet-07ef91e6e6b8d0d41","subnet-0a8fdbfa4ff3b6cc7"] #["${aws_subnet.twPublicSubnet1.id}", "${aws_subnet.twPublicSubnet2.id}"]
  security_groups = ["sg-03b25c25d3ec95b27"] #["${aws_security_group.tw_alb_sg1.id}"]

  tags {
    Name        = "tw-teste-alb1"
  }
}

# Target Group for App
resource "aws_alb_target_group" "twTesteAppTG1" {
  name        = "twTesteAppTG1"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "vpc-05ce30447a6b0b03b" #"${aws_vpc.twVPC1.id}"
  target_type = "instance"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_alb.tw_teste_alb1"]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "tw_teste_app_LBL" {
  load_balancer_arn = "${aws_alb.tw_teste_alb1.arn}"
  port              = "80"
  protocol          = "HTTP"
  depends_on        = ["aws_alb_target_group.twTesteAppTG1"]

  default_action {
    target_group_arn = "${aws_alb_target_group.twTesteAppTG1.arn}"
    type             = "forward"
  }
}