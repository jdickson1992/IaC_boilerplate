output "swarm_manager_0_public_ip" {
    description = "Public IP of the first swarm manager"
    value = aws_instance.swarm-manager.0.public_ip
}
