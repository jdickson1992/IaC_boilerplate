provider "aws" {
  region = var.region
}

module "network" {
  source             = "./modules/network"
  namespace          = var.namespace
  vpc_cidr_prefix    = var.vpc_cidr_prefix
  environment        = var.environment
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "security" {
  source     = "./modules/security"
  depends_on = [module.network]
  vpc_id     = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr
}

module "compute" {
  source                 = "./modules/compute"
  depends_on             = [module.security]
  namespace              = var.namespace
  environment            = var.environment
  swarm_manager_instance = var.swarm_manager_instance
  swarm_worker_instance  = var.swarm_worker_instance
  swarm_managers         = var.swarm_managers
  swarm_workers          = var.swarm_workers
  root_volume_size       = var.root_volume_size
  security_group         = module.security.dockerSG
  vpc_id                 = module.network.vpc_id
}