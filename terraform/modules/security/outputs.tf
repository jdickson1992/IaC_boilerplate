output "dockerSG" {
  value       = aws_security_group.docker.id
  description = "ID for docker SG"
}