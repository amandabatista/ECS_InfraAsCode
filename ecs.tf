/*
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



# Cluster Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = "${file("policies/ecs-task-execution-role.json")}"
}
*/

# ECS Task definition
/* data "template_file" "tw_teste_app_task" {
  template = "${file("tw-teste-task-snapshot.json")}"

  vars {
    image               = "amandamattos/tw_teste_app:snapshot"
    container_name      = "tw_teste_app"
    container_port      = "3000"
    desired_task_cpu    = "1024"
    desired_task_memory = "2048"
  }
} */

resource "aws_ecs_task_definition" "tw-teste-app-task" {
  family                   = "tw_teste_app1"
  requires_compatibilities = ["EC2"]
  cpu                      = "2048"
  memory                   = "4096"
  container_definitions = "${file("task-definitions/tw-teste-task-snapshot.json")}"
  #execution_role_arn = "${aws_iam_role.ecs_execution_role.arn}"
  #task_role_arn      = "${aws_iam_role.ecs_execution_role.arn}"
}

# ECS Cluster Service Definition
resource "aws_iam_role" "ecs-service-role" {
    name                = "ecs-service-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecs-service-policy.json}"
}


resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
    role       = "${aws_iam_role.ecs-service-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs.amazonaws.com"]
        }
    }
}

resource "aws_ecs_service" "test-ecs-service" {
  	name            = "test-ecs-service"
  	iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "teste-cluster" #"${aws_ecs_cluster.tw-cluster.id}"
  	task_definition = "tw_teste_task_snapshot" #"${aws_ecs_task_definition.tw-teste-app-task.arn}"
  	desired_count   = 2

  	load_balancer {
      target_group_arn = "${aws_alb_target_group.twTesteAppTG1.arn}"
      container_name   = "${var.container_name}"
      container_port   = "${var.container_port}"
	  }
}