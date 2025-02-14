# Configure aws provider
provider "aws" {
  region  = var.region
  profile = "terraform-user"
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

# Create nat gatewaye
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


# Create Certificate
module "acm" {
  source            = "../modules/acm"
  domain_name       = var.domain_name
  alternative_name  = var.alternative_name
}


# Create ALB
module "alb" {
  source                = "../modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1
  public_subnet_az2_id  = module.vpc.public_subnet_az2
  vpc_id                = module.vpc.vpc_id 
  certificate_arn       = module.acm.certificate_arn
}


# Create ECS
module "ecs" {
  source                        = "../modules/ecs"
  project_name                  = module.vpc.project_name
  ecs_task_execution_role_arn   = module.ecs_task_execution_role.ecs_task_execution_role_arn
  container_image               = var.container_image
  region                        = module.vpc.region
  private_app_subnet_az1        = module.vpc.private_app_subnet_az1
  private_app_subnet_az2        = module.vpc.private_app_subnet_az2
  ecs_security_group_id         = module.security_group.ecs_security_group_id
  alb_target_group_arn          = module.alb.alb_target_group_arn
}