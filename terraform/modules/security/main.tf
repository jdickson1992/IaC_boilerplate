data "http" "myip" { url = "https://ifconfig.io" }

locals {
  myip = ["${chomp(data.http.myip.response_body)}/32"]
}

resource "aws_security_group" "docker" {
  name        = "docker_swarm"
  description = "docker swarm security group"
  vpc_id      = var.vpc_id
  ingress {
    description = "ssh access from local"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.myip
  }
  ingress {
    description = "HTTP access to NGINX"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS access to NGINX"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Docker swarm management"
    from_port = 2377
    to_port   = 2377
    protocol  = "tcp"
    cidr_blocks = [
      var.vpc_cidr_block
    ]
  }
  ingress {
    description = "Docker container network discovery"
    from_port = 7946
    to_port   = 7946
    protocol  = "tcp"
    cidr_blocks = [
      var.vpc_cidr_block
    ]
  }
  ingress {
    description = "Docker container network discovery"
    from_port = 7946
    to_port   = 7946
    protocol  = "udp"
    cidr_blocks = [
      var.vpc_cidr_block
    ]
  }
  ingress {
    description = "Docker overlay network"
    from_port = 4789
    to_port   = 4789
    protocol  = "tcp"
    cidr_blocks = [
      var.vpc_cidr_block
    ]
  }
  ingress {
    description = "Docker overlay network"
    from_port = 4789
    to_port   = 4789
    protocol  = "udp"
    cidr_blocks = [
      var.vpc_cidr_block
    ]
  }

  ingress {
    description = "Blue-Green Applications"
    from_port = 8080
    to_port   = 8081
    protocol  = "tcp"
    cidr_blocks = [
      var.vpc_cidr_block
    ]
  }

  egress {
    description = "Outside world"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}