variable "namespace" {
  type = string
}

variable "vpc_cidr_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "availability_zones" {
  type        = list(any)
  description = "Availability zones"
}

variable "public_subnets" {
  type        = map(any)
  description = "Map of AZ as keys and subnets as values"
  default     = {}
}