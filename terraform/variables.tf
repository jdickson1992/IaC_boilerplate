variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  default     = "taco-test"
  type        = string
}

variable "vpc_cidr_prefix" {
  description = "The CIDR block prefix for the VPC"
  default     = "172.16"
  type        = string
}

variable "environment" {
  description = "Infrastructure environment"
  default     = "dev"
  type        = string
}

variable "swarm_manager_instance" {
  description = "The size of the swarm manager machine"
  default     = "t3.micro"
  type        = string
}

variable "swarm_managers" {
  description = "The number of swarm managers to create"
  default     = 1
}

variable "swarm_worker_instance" {
  description = "The size of the swarm workers"
  default     = "t3.micro"
  type        = string
}

variable "swarm_workers" {
  description = "The number of swarm managers to create"
  default     = 4
}

variable "root_volume_size" {
  description = "The size of the root volume"
  type        = string
  default     = 16
}
