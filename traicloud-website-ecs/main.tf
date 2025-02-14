# Configure aws provider
provider "aws" {
  region  = var.region
  profile = "awspsa"
}

# Create VPC
module "vpc" {
  source                        = "../modules/vpc"
  region                        = var.region
  project_name                  = var.project_name
  project_type                  = var.project_type
  environment                   = var.environment
  vpc_cidr                      = var.vpc_cidr
  public_subnet_az1_cidr        = var.public_subnet_az1_cidr
  public_subnet_az2_cidr        = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr   = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr   = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr  = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr  = var.private_data_subnet_az2_cidr
}

# Create nate gatewaye
module "nat_gateway" {
  source                        = "../modules/nat-gateway"
  public_subnet_az1             = module.vpc.public_subnet_az1
  internet_gateway              = module.vpc.internet_gateway
  public_subnet_az2             = module.vpc.public_subnet_az2
  vpc_id                        = module.vpc.vpc_id
  private_app_subnet_az1        = module.vpc.private_app_subnet_az1
  private_app_subnet_az2        = module.vpc.private_app_subnet_az2
  private_data_subnet_az1       = module.vpc.private_data_subnet_az1
  private_data_subnet_az2       = module.vpc.private_data_subnet_az2
}

# Create security group
module "security_group" {
  source                        = "../modules/security-groups"
  vpc_id                        = module.vpc.vpc_id
  
}

# Create ECS Task Definition
module "ecs_task_execution_role" {
  source                        = "../modules/ecs-task-execution-role"
  project_name                  = module.vpc.project_name
}
