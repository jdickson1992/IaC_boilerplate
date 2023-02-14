output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnets" {
  value       = local.public_subnets
  description = "Computed public subnet CIDR blocks"
}