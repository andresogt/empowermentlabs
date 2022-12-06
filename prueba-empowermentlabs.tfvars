#Network Module

region               = "us-east-1"
vpc_cidr             = "172.33.0.0/16"
public_subnet1_cidr  = "172.33.0.0/19"
public_subnet2_cidr  = "172.33.32.0/19"
private_subnet1_cidr = "172.33.64.0/19"
private_subnet2_cidr = "172.33.96.0/19"
private_subnet3_cidr = "172.33.128.0/19"
private_subnet4_cidr = "172.33.160.0/19"
private_subnet5_cidr = "172.33.192.0/19"
private_subnet6_cidr = "172.33.224.0/19"

tags                 = "VPC Prueba empowermentlabs DevOps"

#ECS Module
container_port             = "8000"
ecr_name_fe                   = "ecr-empowermentlabs-fe"
ecr_name_be                   = "ecr-empowermentlabs-be"