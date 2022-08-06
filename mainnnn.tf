/*
# Create vpc
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.10.0.0/16"
}

# Create public subnet
module "public_subnets" {
  source     = "./modules/public_subnet"
  cidr_block = ["10.10.0.0/24", "10.10.1.0/24"]
  vpc_id     = module.vpc.vpc_id

}

# Create private subnets
module "private_subnets" {
  source     = "./modules/private_subnet"
  cidr_block = ["10.10.11.0/24", "10.10.12.0/24"]
  vpc_id     = module.vpc.vpc_id
}
# Create IGW
module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

# Create NAT
module "natgtw" {
  source    = "./modules/natgw"
  subnet_id = module.public_subnets.public_subnet_id[0]
}

# Create public route data "aws_qldb_ledger" "example" {
module "public_route_table" {
  source = "./modules/public_route_table"
  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
}

# Public rt association
module "rtb_public_subnet_association" {
  source         = "./modules/route_table_association"
  subnet_id      = module.public_subnets.public_subnet_id[*]
  route_table_id = module.public_route_table.public_route_table_id
}

# Create Private rt
module "private_route_table" {
  source   = "./modules/private_route_table"
  vpc_id   = module.vpc.vpc_id
  natgw_id = module.natgtw.natgw_id
}

# Private rt assiociation
module "rtb_private_subnet_association" {
  source         = "./modules/route_table_association"
  subnet_id      = module.private_subnets.private_subnet_id[*]
  route_table_id = module.private_route_table.private_route_table_id
}

# Create sg for ALB
module "alb_sg" {
  source  = "./modules/alb_sg"
  sg_name = "alb_sg"
  vpc_id  = module.vpc.vpc_id
}

# Add ingress rules for ALB sg
module "alb_sg_ingress_rules" {
  source = "./modules/rule_simple"
  type   = "ingress"
  rules = {
    "0" = ["0.0.0.0/0", "80", "80", "TCP", "allow http from www"]
    "1" = ["0.0.0.0/0", "443", "443", "TCP", "allow http from www"]
  }
  security_group_id = module.alb_sg.alb_sg_id

}

# Add egress rules for ALB sg
module "alb_sg_egress_rules" {
  source = "./modules/rule_simple"
  type   = "egress"
  rules = {
    "0" = ["0.0.0.0/0", "0", "65535", "TCP", "allow outbound traffic to www"]
  }
  security_group_id = module.alb_sg.alb_sg_id
}

#Create sg for ec2
module "ec2_sg" {
  source  = "./modules/security_group"
  sg_name = "ec2-sg"
  vpc_id  = module.vpc.vpc_id

}

# Add ingress rules for EC2 SG
module "ec2_sg_ingress_rules" {
  source = "./modules/rule_simple"
  type   = "ingress"
  rules = {
    "0" = ["0.0.0.0/0", "22", "22", "TCP", "allow ssh from www"]
  }
  security_group_id = module.ec2_sg.security_group_id
}

# Add ingress rules for EC2 sg to allow http traffic from ALB sg
module "ec2_sg_ingress_rules_from_alb" {
  source = "./modules/rule_with_id"
  type   = "ingress"
  rules = {
    "0" = [module.alb_sg.alb_sg_id, "80", "80", "TCP", "allow http traffic from ALB"]
  }
  security_group_id = module.ec2_sg.security_group_id
}

# Add egress rules for EC2 SG
module "ec2_sg_egress_rules" {
  source = "./modules/rule_simple"
  type   = "egress"
  rules = {
    "0" = ["0.0.0.0/0", "0", "65535", "TCP", "allow outbound traffic to www"]
  }
  security_group_id = module.ec2_sg.security_group_id
}

# Create EC2
module "ec2" {
  source                = "./modules/ec2"
  subnet_id             = module.private_subnets.private_subnet_id[*]
  vpc_security_group_id = [module.ec2_sg.security_group_id]

  depends_on = [
    module.natgtw
  ]
}

# Create target group of EC2s
module "target_group" {
  source = "./modules/target_group"
  vpc_id = module.vpc.vpc_id
}

# attach both EC2s to target group
module "ec2_attachment" {
  source           = "./modules/target_group_attachment"
  target_group_arn = module.target_group.target_group_arn
  instance_id      = module.ec2.instance_id[*]
}

#Create alb
module "alb" {
  source = "./modules/alb"
  alb_sg = [module.alb_sg.alb_sg_id]
  alb_subnets = module.public_subnets.public_subnet_id[*]
  target_group_arn = module.target_group.target_group_arn
}

# Create db subnet group
module "db_subnet_group" {
  source = "./modules/subnet_group"
  subnet_id = module.private_subnets.private_subnet_id[*]
}

# Create DB subnet group
module "db_sg" {
  source = "./modules/security_group"
  sg_name = "db-sg"
  vpc_id = module.vpc.vpc_id
}

# Add ingress rules for db sg to allow http traffic from EC sg
module "db_sg_ingress_from_ec2" {
  source = "./modules/rule_with_id"
  type = "ingress"
  rules = {
    "0" = [module.ec2_sg.security_group_id, "3306", "3306", "TCP", "allow httpd traffic from EC2"]
  }
  security_group_id = module.db_sg.security_group_id
  
}

# Add egress rules for db sg
module "db_sg_egress_rules" {
  source = "./modules/rule_simple"
  type  = "egress"
  rules = {
    "0" = ["0.0.0.0/0", "0", "65335", "TCP", "allow outbound traffic to www"]
  }
  security_group_id = module.db_sg.security_group_id
}

# Create db
module "db" {
  source = "./modules/rds"
  db_security_group_id = [module.db_sg.security_group_id]
  db_subnet_group_name = module.db_subnet_group.db_subnet_group_id
}

# Create DNS record
module "dns_record" {
  source = "./modules/dns"
  alb_dns_name = [module.alb.alb_dns_name]
}
*/
