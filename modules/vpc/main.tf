#Create VPC
resource "aws_vpc" "trai_vpc" {
  cidr_block            = var.vpc_cidr
  instance_tenancy      = "default"
  enable_dns_hostnames  = true

  tags = {
    Name = "${var.project_name}-vpc"
    Environment = var.environment
    ProjectType = var.project_name
  }
}

resource "aws_internet_gateway" "trai_igw" {
  vpc_id = aws_vpc.trai_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
    Environment = var.environment
    ProjectType = var.project_name
  }
}

# Use data source to get all availability zones in region
data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.trai_vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az1"
    Environment = var.environment
    ProjectType = var.project_name
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.trai_vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az2"
    Environment = var.environment
    ProjectType = var.project_name
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id          = aws_vpc.trai_vpc.id

  route {
    cidr_block    = "0.0.0.0/0"
    gateway_id    = aws_internet_gateway.trai_igw.id
  }

  tags = {
    Name = "public route table"
    Environment = var.environment
    ProjectType = var.project_name
  }
}

resource "aws_route_table_association" "public_subnet_az1_route_table_associate" {
  subnet_id       = aws_subnet.public_subnet_az1.id
  route_table_id  = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2_route_table_associate" {
  subnet_id       = aws_subnet.public_subnet_az2.id
  route_table_id  = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                  = aws_vpc.trai_vpc.id
  cidr_block              = var.private_app_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "private app subnet az1"
    Environment = var.environment
    ProjectType = var.project_name
  } 
}

resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                  = aws_vpc.trai_vpc.id
  cidr_block              = var.private_app_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "private app subnet az2"
    Environment = var.environment
    ProjectType = var.project_name
  } 
}

resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                  = aws_vpc.trai_vpc.id
  cidr_block              = var.private_data_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "private data subnet az1"
    Environment = var.environment
    ProjectType = var.project_name
  } 
}

resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                  = aws_vpc.trai_vpc.id
  cidr_block              = var.private_data_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "private data subnet az2"
    Environment = var.environment
    ProjectType = var.project_name
  } 
}