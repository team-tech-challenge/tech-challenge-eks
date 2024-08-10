#####################################
#                                   #
#         AWS VPC Module            #
#                                   #
#####################################

module "aws_vpc" {
  source = "git::git@github.com:team-tech-challenge/terraform-modules-remotes.git//aws_vpc?ref=feat/module_eks"

  create_vpc           = var.create_network_infrastructure
  vpc_cidr_block       = var.cidr_block
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames
  tags = merge({
    "Name" = "vpc-prd-eks-tech"
    "CIDR" = var.cidr_block
    },
    var.eks_tags
  )
}

#####################################
#                                   #
#         AWS Subnet Module         #
#                                   #
#####################################

module "aws_subnets" {
  source = "git::git@github.com:team-tech-challenge/terraform-modules-remotes.git//aws_subnets?ref=feat/module_eks"

  create_subnet       = var.create_network_infrastructure
  id_vpc              = module.aws_vpc.vpc_id
  availability_zones  = data.aws_availability_zones.available.names
  public_subnet_cidr  = var.public_subnets
  private_subnet_cidr = var.private_subnets
  tags_subnets        = var.eks_tags
}


#########################################
#                                       #
#         AWS Route Table Module        #
#                                       #
#########################################

module "aws_route_table" {
  source = "git::git@github.com:team-tech-challenge/terraform-modules-remotes.git//aws_route_table?ref=feat/module_eks"

  create_route_table  = var.create_network_infrastructure
  name_prefix         = "rtb-${var.name_prefix}"
  vpc_id              = module.aws_vpc.vpc_id
  public_subnet_ids   = module.aws_subnets.public_subnets
  private_subnet_ids  = module.aws_subnets.private_subnets
  nat_gateway_id      = module.aws_nat_gateway.nat_gateway_id
  cidr_block          = "0.0.0.0/0"
  internet_gateway_id = module.aws_internet_gateway.internet_gateway_id
}

#########################################
#                                       #
#         AWS Internet Gateway          #
#                                       #
#########################################

module "aws_internet_gateway" {
  source = "git::git@github.com:team-tech-challenge/terraform-modules-remotes.git//aws_internet_gateway?ref=feat/module_eks"

  create_internet_gateway = var.create_network_infrastructure
  vpc_id                  = module.aws_vpc.vpc_id
}

#########################################
#                                       #
#         AWS NAT Gateway Module        #
#                                       #
#########################################

module "aws_nat_gateway" {
  source = "git::git@github.com:team-tech-challenge/terraform-modules-remotes.git//aws_nat_gateway?ref=feat/module_eks"

  create_nat_gateway = var.create_network_infrastructure
  name_prefix        = var.name_prefix
  public_subnet_id   = element(module.aws_subnets.public_subnets, 0)
}


#########################################
#                                       #
#         AWS Network ACL Private       #
#                                       #
#########################################

module "public_network_acl" {
  source = "git::git@github.com:team-tech-challenge/terraform-modules-remotes.git//aws_network_acl?ref=feat/module_eks"

  create_network_acl        = var.create_network_infrastructure
  aws_net_acl_vpc_id        = module.aws_vpc.vpc_id
  aws_net_acl_subnet_ids    = module.aws_subnets.public_subnets
  aws_net_acl_ingress_rules = var.public_network_acl_ingress_rules
  aws_net_acl_egress_rules  = var.public_network_acl_egress_rules
  aws_net_acl_tags = merge({
    "Name" = "acl-public-${var.name_prefix}"
    },
    var.eks_tags
  )
}

#########################################
#                                       #
#       AWS Network ACL Private         #
#                                       #
#########################################

module "private_network_acl" {
  source = "git::git@github.com:team-tech-challenge/terraform-modules-remotes.git//aws_network_acl?ref=feat/module_eks"

  create_network_acl        = var.create_network_infrastructure
  aws_net_acl_vpc_id        = module.aws_vpc.vpc_id
  aws_net_acl_subnet_ids    = module.aws_subnets.private_subnets
  aws_net_acl_ingress_rules = var.private_network_acl_ingress_rules
  aws_net_acl_egress_rules  = var.private_network_acl_egress_rules
  aws_net_acl_tags = merge({
    "Name" = "acl-private-${var.name_prefix}"
    },
    var.eks_tags
  )
}

