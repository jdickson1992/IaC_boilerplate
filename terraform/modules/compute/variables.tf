variable "vpc_id" {
  type = string
}

variable "key_pair_name" {
  type    = string
  default = "test"
}

variable "swarm_manager_instance" {
  type = string
}

variable "swarm_worker_instance" {
  type = string
}

variable "swarm_managers" {
  type = string
}

variable "swarm_workers" {
  type = string
}

variable "security_group" {

}

variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "root_volume_size" {
  type = string
}

