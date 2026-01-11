terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source     = "./modules/ec2"
  subnet_id = module.vpc.public_subnets[0]
  jenkins_ip = "52.66.213.248"
  key_name   = "devops-key"
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets
  instance_id = module.ec2.instance_id
}

