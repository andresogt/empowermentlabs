module "network" {
    source = "./src/modules/network"
    
    vpc_cidr             = var.vpc_cidr
    public_subnet1_cidr  = var.public_subnet1_cidr
    public_subnet2_cidr  = var.public_subnet2_cidr
    private_subnet1_cidr = var.private_subnet1_cidr
    private_subnet2_cidr = var.private_subnet2_cidr
    private_subnet3_cidr = var.private_subnet3_cidr
    private_subnet4_cidr = var.private_subnet4_cidr
    private_subnet5_cidr = var.private_subnet5_cidr
    private_subnet6_cidr = var.private_subnet6_cidr
    tags                 = var.tags
}


module "ecs" {
    source = "./src/modules/ecs"
    
    vpc_id               = module.network.vpc_id
    private_subnet1_id   = module.network.private_subnet1_id
    private_subnet2_id   = module.network.private_subnet2_id
    private_subnet3_id   = module.network.private_subnet3_id
    private_subnet4_id   = module.network.private_subnet4_id
    public_subnet1_id   = module.network.public_subnet1_id
    public_subnet2_id   = module.network.public_subnet2_id
    container_port       = var.container_port
    ecr_name_fe           = var.ecr_name_fe
    ecr_name_be           = var.ecr_name_be
}

module "rds" {
    source = "./src/modules/rds"
    sg-be-id = module.ecs.sg-backend-id
    private_subnet5_id = module.network.private_subnet5_id
    private_subnet6_id = module.network.private_subnet6_id
}

module "waf" {
    source = "./src/modules/waf"
    arn_alb_fe = module.ecs.alb_fe_arn
}

module "parameter" {
    source = "./src/modules/parameter"
    ecr_url = module.ecs.ecr_url
    ecs_name = module.ecs.ecs_name
}

module "codebuild" {
    source = "./src/modules/codebuild"
}

