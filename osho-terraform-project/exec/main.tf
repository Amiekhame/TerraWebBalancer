provider "aws" {
    region   = var.region
    profile = "osho"
}

module "vpc_modules" {
    source = "../modules/vpc_modules"
    project_name = var.project_name
    cidr_block = var.cidr_block
    subnet_a_cidr_block = var.subnet_a_cidr
    subnet_b_cidr_block = var.subnet_b_cidr
    subnet_c_cidr_block = var.subnet_c_cidr
}

module "security_modules" {
    source = "../modules/security_modules"
    vpc_id = module.vpc_modules.vpc_id
    project_name = var.project_name
}

module "instance_modules" {
    source = "../modules/instance_modules"
    ami = var.ami
    project_name = var.project_name
    instance_type = var.instance_type
    sg_1_id = module.security_modules.sg_1_id
    subnet_a_id = module.vpc_modules.subnet_a_id
    subnet_b_id = module.vpc_modules.subnet_b_id
    subnet_c_id = module.vpc_modules.subnet_c_id
}

module "load_balancer_modules" {
    source = "../modules/load_balancer_modules"
    project_name = var.project_name
    vpc_id = module.vpc_modules.vpc_id
    subnet_a_id = module.vpc_modules.subnet_a_id
    subnet_b_id = module.vpc_modules.subnet_b_id
    subnet_c_id = module.vpc_modules.subnet_c_id
    sg_2_id = module.security_modules.sg_2_id
    
}

module "route_53_modules" {
    source = "../modules/route_53_modules"
    project_name = var.project_name
    domain_name = var.domain_name
    subdomain_name = var.subdomain_name
    application_load_balancer_dns_name = module.load_balancer_modules.application_load_balancer_dns_name
    application_load_balancer_zone_id = module.load_balancer_modules.application_load_balancer_zone_id
}


