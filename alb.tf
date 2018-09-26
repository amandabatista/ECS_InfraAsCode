#Define application load balancer
resource "aws_alb" "tw_app_alb" {
  name            = "tw-teste-alb"
  subnets         = ["${aws_subnet.twPublicSubnet1.id}", "${aws_subnet.twPublicSubnet2.id}"]
  security_groups = ["${aws_security_group.tw_alb_sg.id}"]

  tags {
    Name        = "tw-teste-alb"
  }
}

# Target Group for App
resource "aws_alb_target_group" "tw_teste_app_TG" {
  name        = "tw-teste-app-target-group"
  port        = "${var.container_port}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.twVPC.id}"
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_alb.tw_app_alb"]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "tw_teste_app_LBL" {
  load_balancer_arn = "${aws_alb.tw_app_alb.arn}"
  port              = "3000"
  protocol          = "HTTP"
  depends_on        = ["aws_alb_target_group.tw_teste_app_TG"]

  default_action {
    target_group_arn = "${aws_alb_target_group.tw_teste_app_TG.arn}"
    type             = "forward"
  }
}