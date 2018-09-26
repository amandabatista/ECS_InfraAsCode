# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "ecs_cluster" {
  description = "ECS cluster name"
}

/*variable "ecs_key_pair_name" {
  description = "EC2 instance key pair name"
}*/

variable "region" {
  description = "AWS region"
}

variable "availability_zone1" {
  description = "First availability zone used for the project"
}

variable "availability_zone2" {
  description = "Second availability zone used for the project"
}

########################### Test VPC Config ################################

variable "project_vpc" {
  description = "VPC name for Project"
}

variable "project_network_cidr" {
  description = "IP addressing for project Network"
}

variable "project_public_01_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

variable "project_public_02_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

########################### ECS ################################
variable "container_name" {
  description = "Container Name"
}

variable "container_port" {
  description = "3000"
}

########################### Autoscale Config ################################

/*variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}*/