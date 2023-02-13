# -----------------------------------------------------------------------------
# AMI
# Get AMI ID for amazon linux 2 box
# -----------------------------------------------------------------------------
data "aws_ami" "ami" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-minimal-hvm-*"]
  }
}

data "aws_subnets" "current" {
  filter {
    name = "vpc-id"
    values = [var.vpc_id]
  }
}

# -----------------------------------------------------------------------------
# Private key
# Createsa temporary private key which will be used for testing ssh access to swarm servers
# -----------------------------------------------------------------------------
resource "tls_private_key" "tls_connector" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "testKeyPair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.tls_connector.public_key_openssh
}

resource "local_file" "priv_key" {
  content         = tls_private_key.tls_connector.private_key_pem
  filename        = "test.pem"
  file_permission = "0600"
}

resource "local_file" "pub_key" {
  content         = tls_private_key.tls_connector.public_key_openssh
  filename        = "test.pub"
  file_permission = "0600"
}

# -----------------------------------------------------------------------------
# Create EC2 instances
# These resources will create a swarm manager node[s] and swarm workers
# -----------------------------------------------------------------------------
resource "aws_instance" "swarm-manager" {
  count                  = var.swarm_managers
  ami                    = data.aws_ami.ami.id
  subnet_id              = tolist(data.aws_subnets.current.ids)[count.index % length(data.aws_subnets.current.ids)]
  instance_type          = var.swarm_manager_instance
  key_name               = aws_key_pair.testKeyPair.key_name
  vpc_security_group_ids = [var.security_group]
  user_data              = <<EOF
                #!/bin/bash
                sudo hostnamectl set-hostname "swarm-manager-${count.index}"
                sudo amazon-linux-extras enable ansible2
  EOF

  root_block_device {
    encrypted   = true
    volume_size = var.root_volume_size
    volume_type = "gp2"
  }

  tags = {
    Terraform   = "true"
    Name        = "swarm-manager-${count.index}"
    Environment = "${var.environment}"
  }
}

resource "aws_instance" "swarm-worker" {
  count                  = var.swarm_workers
  ami                    = data.aws_ami.ami.id
  subnet_id              = tolist(data.aws_subnets.current.ids)[count.index % length(data.aws_subnets.current.ids)]
  instance_type          = var.swarm_worker_instance
  key_name               = aws_key_pair.testKeyPair.key_name
  vpc_security_group_ids = [var.security_group]
  user_data              = <<EOF
                #!/bin/bash
                sudo hostnamectl set-hostname "swarm-worker-${count.index}"
                sudo amazon-linux-extras enable ansible2
  EOF 

  root_block_device {
    encrypted   = true
    volume_size = var.root_volume_size != "" ? var.root_volume_size : "16"
    volume_type = "gp2"
  }

  tags = {
    Terraform   = "true"
    Name        = "swarm-worker-${count.index}"
    Environment = "${var.environment}"
  }
}

# -----------------------------------------------------------------------------
# Generates an ansible inventory file contain worker / manager nodes IPs
# -----------------------------------------------------------------------------
resource "local_file" "ansible_inventory" {
  content = templatefile("./modules/compute/templates/inventory.tmpl",
    {
      manager    = aws_instance.swarm-manager[*].tags["Name"]
      worker     = aws_instance.swarm-worker[*].tags["Name"]
      manager_ip = aws_instance.swarm-manager.*.public_ip
      worker_ip  = aws_instance.swarm-worker.*.public_ip
    }
  )

  filename        = "../ansible/inventory.ini"
  file_permission = "0644"
}