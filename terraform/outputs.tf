output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.network.vpc_cidr
}

output "public_subnets" {
  description = "Computed Public Subnet CIDR blocks"
  value = module.network.public_subnets
}

output "swarm_manager_public_ip" {
    description = "Public IP of the first swarm manager"
    value = module.compute.swarm_manager_0_public_ip
}
