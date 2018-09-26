# ECS Cluster definition
resource "aws_ecs_cluster" "tw-cluster" {
  name = "${var.ecs_cluster}"
}

resource "aws_cloudwatch_log_group" "tw-web-app" {
  name = "${var.ecs_cluster}-logs"

  tags {
    Application = "tw-teste-app"
  }
}

# ECR Definition
resource "aws_ecr_repository" "tw-teste-ecr" {
  name = "tw-teste-ecr"
}

data "template_file" "tw_teste_app_task" {
  template = "${file("tw-teste-app-task.json")}"

  vars {
    image               = "${aws_ecr_repository.tw-teste-ecr.repository_url}"
    container_name      = "${var.container_name}"
    container_port      = "3000"
    log_group           = "${aws_cloudwatch_log_group.tw-web-app.name}"
    desired_task_cpu    = "2048"
    desired_task_memory = "4096"
  }
}

# Cluster Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = "${file("policies/ecs-task-execution-role.json")}"
}

# ECS Task definition
resource "aws_ecs_task_definition" "tw-teste-app-task" {
  family                   = "tw_teste_app"
  container_definitions    = "${data.template_file.tw_teste_app_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "2048"
  memory                   = "4096"

  execution_role_arn = "${aws_iam_role.ecs_execution_role.arn}"
  task_role_arn      = "${aws_iam_role.ecs_execution_role.arn}"
}

# ECS Service Policy
data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
    ]
  }
}

data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_role.json}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
  role   = "${aws_iam_role.ecs_role.id}"
}

# ECS Service definition
resource "aws_ecs_service" "tw-teste-app-service" {
  name            = "tw-teste-app-ecs-service"
  task_definition = "${aws_ecs_task_definition.tw-teste-app-task.arn}"
  cluster         = "${aws_ecs_cluster.tw-cluster.id}"
  launch_type     = "FARGATE"
  desired_count   = "2"

  depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

  network_configuration {
    security_groups  = ["${aws_security_group.tw_ecs_service_sg.id}"]
    subnets          = ["${aws_subnet.twPublicSubnet1.id}", "${aws_subnet.twPublicSubnet2.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.tw_teste_app_TG.arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
  }

  depends_on = ["aws_alb_target_group.api_target_group"]
}
