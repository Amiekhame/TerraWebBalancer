# TerraWebBalancer

# Terraform Infrastructure Deployment

This repository contains Terraform code to deploy a scalable and resilient infrastructure on AWS. The infrastructure includes a Virtual Private Cloud (VPC) with public and private subnets, instances deployed across multiple availability zones, security groups, an Application Load Balancer (ALB), and Route 53 DNS records.

## Modules

The infrastructure is organized into several modules for better maintainability and reusability.

### [VPC Module](./modules/vpc_modules)

The VPC module is responsible for creating the VPC, subnets, an internet gateway, route tables, and associating subnets with route tables.

#### Usage:

```hcl
module "vpc_modules" {
    source              = "../modules/vpc_modules"
    project_name        = var.project_name
    cidr_block          = var.cidr_block
    subnet_a_cidr_block = var.subnet_a_cidr
    subnet_b_cidr_block = var.subnet_b_cidr
    subnet_c_cidr_block = var.subnet_c_cidr
}
```

### [Security Module](./modules/security_modules)

The Security module manages security groups to control inbound and outbound traffic for instances.

#### Usage:

```hcl
module "security_modules" {
    source      = "../modules/security_modules"
    vpc_id      = module.vpc_modules.vpc_id
    project_name = var.project_name
}
```

### [Instance Module](./modules/instance_modules)

The Instance module provisions EC2 instances with specified AMIs, instance types, key pairs, and security groups.

#### Usage:

```hcl
module "instance_modules" {
    source        = "../modules/instance_modules"
    ami           = var.ami
    project_name  = var.project_name
    instance_type = var.instance_type
    sg_1_id       = module.security_modules.sg_1_id
    subnet_a_id   = module.vpc_modules.subnet_a_id
    subnet_b_id   = module.vpc_modules.subnet_b_id
    subnet_c_id   = module.vpc_modules.subnet_c_id
}
```

### [Load Balancer Module](./modules/load_balancer_modules)

The Load Balancer module sets up an Application Load Balancer (ALB) and related resources.

#### Usage:

```hcl
module "load_balancer_modules" {
    source         = "../modules/load_balancer_modules"
    project_name   = var.project_name
    vpc_id         = module.vpc_modules.vpc_id
    subnet_a_id    = module.vpc_modules.subnet_a_id
    subnet_b_id    = module.vpc_modules.subnet_b_id
    subnet_c_id    = module.vpc_modules.subnet_c_id
    sg_2_id        = module.security_modules.sg_2_id
}
```

### [Route 53 Module](./modules/route_53_modules)

The Route 53 module creates a hosted zone and DNS records for the specified domain and subdomain.

#### Usage:

```hcl
module "route_53_modules" {
    source                                 = "../modules/route_53_modules"
    project_name                           = var.project_name
    domain_name                            = var.domain_name
    subdomain_name                         = var.subdomain_name
    application_load_balancer_dns_name    = module.load_balancer_modules.application_load_balancer_dns_name
    application_load_balancer_zone_id      = module.load_balancer_modules.application_load_balancer_zone_id
}
```

## Variables

This Terraform configuration relies on the following variables:

- `region`: AWS region for deployment.
- `project_name`: Unique name for the project.
- `instance_type`: EC2 instance type.
- `cidr_block`: VPC CIDR block.
- `subnet_a_cidr`, `subnet_b_cidr`, `subnet_c_cidr`: CIDR blocks for subnets.
- `ami`: AMI ID for EC2 instances.
- `domain_name`: Root domain for Route 53.
- `subdomain_name`: Subdomain for Route 53.

## Outputs

The Terraform configuration provides the following outputs:

- `alb_target_group_arn`: ARN of the ALB target group.
- `application_load_balancer_dns_name`: DNS name of the ALB.
- `application_load_balancer_zone_id`: Zone ID of the ALB.

## Execution

To deploy the infrastructure, execute the following commands:

```sh
terraform init
terraform apply
```

Ensure that AWS credentials are properly configured with the necessary permissions.

## Cleanup

To destroy the deployed infrastructure, run:

```sh
terraform destroy
```

