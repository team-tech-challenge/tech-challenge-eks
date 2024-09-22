#####################################
#                                   #
#         AWS VPC Module            #
#                                   #
#####################################

module "aws_vpc" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_vpc?ref=feat/module_eks"

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

module "aws_subnets_public" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_subnets?ref=feat/module_eks"

  create_subnet       = var.create_network_infrastructure
  id_vpc              = module.aws_vpc.vpc_id
  availability_zones  = data.aws_availability_zones.available.names
  public_subnet_cidr  = var.public_subnets
  private_subnet_cidr = []
  tags_subnets = merge({
    "Name" = "subnet-public-${var.name_prefix}"
    },
    var.eks_tags
  )

  depends_on = [module.aws_vpc]
}

#####################################
#                                   #
#         AWS Subnet Module         #
#                                   #
#####################################

module "aws_subnets_privates" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_subnets?ref=feat/module_eks"

  create_subnet       = var.create_network_infrastructure
  id_vpc              = module.aws_vpc.vpc_id
  availability_zones  = data.aws_availability_zones.available.names
  public_subnet_cidr  = []
  private_subnet_cidr = var.private_subnets
  tags_subnets = merge({
    "Name" = "subnet-private-${var.name_prefix}"
  }, var.eks_tags)

  depends_on = [module.aws_vpc]
}


###########################################
#                                         #
#      AWS Subnet Database Module         #
#                                         #
###########################################

module "aws_subnets_database" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_subnets?ref=feat/module_eks"

  create_subnet       = var.create_network_infrastructure
  id_vpc              = module.aws_vpc.vpc_id
  availability_zones  = data.aws_availability_zones.available.names
  private_subnet_cidr = var.database_subnets
  tags_subnets = merge({
    "Name" = "subnet-database-${var.name_prefix}"
  }, var.eks_tags)

  depends_on = [module.aws_vpc]
}


#########################################
#                                       #
#         AWS Route Table Module        #
#                                       #
#########################################

module "aws_route_table" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_route_table?ref=feat/module_eks"

  create_route_table  = var.create_network_infrastructure
  name_prefix         = "rtb-${var.name_prefix}"
  vpc_id              = module.aws_vpc.vpc_id
  public_subnet_ids   = module.aws_subnets_public.public_subnets
  private_subnet_ids  = module.aws_subnets_privates.private_subnets
  nat_gateway_id      = module.aws_nat_gateway.nat_gateway_id
  cidr_block          = "0.0.0.0/0"
  internet_gateway_id = module.aws_internet_gateway.internet_gateway_id

  depends_on = [module.aws_vpc, module.aws_internet_gateway, module.aws_nat_gateway, module.aws_subnets_public, module.aws_subnets_privates]
}

###############################################
#                                             #
#      AWS Route Table Database Module        #
#                                             #
###############################################

module "aws_route_table_database" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_route_table?ref=feat/module_eks"

  create_route_table = var.create_network_infrastructure
  name_prefix        = "rtb-database-${var.name_prefix}"
  vpc_id             = module.aws_vpc.vpc_id
  private_subnet_ids = module.aws_subnets_database.private_subnets

  depends_on = [module.aws_vpc, module.aws_subnets_database]
}


#########################################
#                                       #
#         AWS Internet Gateway          #
#                                       #
#########################################

module "aws_internet_gateway" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_internet_gateway?ref=feat/module_eks"

  create_internet_gateway = var.create_network_infrastructure
  vpc_id                  = module.aws_vpc.vpc_id

  depends_on = [module.aws_vpc]
}

#########################################
#                                       #
#         AWS NAT Gateway Module        #
#                                       #
#########################################

module "aws_nat_gateway" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_nat_gateway?ref=feat/module_eks"

  create_nat_gateway = var.create_network_infrastructure
  name_prefix        = var.name_prefix
  public_subnet_id   = length(module.aws_subnets_public.public_subnets) > 0 ? element(module.aws_subnets_public.public_subnets, 0) : null


  depends_on = [module.aws_vpc, module.aws_subnets_public]
}


#########################################
#                                       #
#         AWS Network ACL Private       #
#                                       #
#########################################

module "network_acl_public" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_network_acl?ref=feat/module_eks"

  create_network_acl        = var.create_network_infrastructure
  aws_net_acl_vpc_id        = module.aws_vpc.vpc_id
  aws_net_acl_subnet_ids    = module.aws_subnets_public.public_subnets
  aws_net_acl_ingress_rules = var.public_network_acl_ingress_rules
  aws_net_acl_egress_rules  = var.public_network_acl_egress_rules
  aws_net_acl_tags = merge({
    "Name" = "network-acl-public-${var.name_prefix}"
    },
    var.eks_tags
  )

  depends_on = [module.aws_vpc, module.aws_subnets_public]
}

#########################################
#                                       #
#       AWS Network ACL Private         #
#                                       #
#########################################

module "network_acl_private" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_network_acl?ref=feat/module_eks"

  create_network_acl        = var.create_network_infrastructure
  aws_net_acl_vpc_id        = module.aws_vpc.vpc_id
  aws_net_acl_subnet_ids    = module.aws_subnets_privates.private_subnets
  aws_net_acl_ingress_rules = var.private_network_acl_ingress_rules
  aws_net_acl_egress_rules  = var.private_network_acl_egress_rules
  aws_net_acl_tags = merge({
    "Name" = "network-acl-private-${var.name_prefix}"
    },
    var.eks_tags
  )

  depends_on = [module.aws_vpc, module.aws_subnets_privates]
}

#########################################
#                                       #
#       AWS Network ACL Databases       #
#                                       #
#########################################

module "network_acl_database" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_network_acl?ref=feat/module_eks"

  create_network_acl        = var.create_network_infrastructure
  aws_net_acl_vpc_id        = module.aws_vpc.vpc_id
  aws_net_acl_subnet_ids    = module.aws_subnets_database.private_subnets
  aws_net_acl_ingress_rules = var.databases_network_acl_ingress_rules
  aws_net_acl_egress_rules  = var.databases_network_acl_egress_rules
  aws_net_acl_tags = merge({
    "Name" = "network-acl-database-${var.name_prefix}"
    },
    var.eks_tags
  )

  depends_on = [module.aws_vpc, module.aws_subnets_database]
}

#########################################
#                                       #
#       AWS Security Group Public       #
#                                       #
#########################################

module "aws_security_group_public" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_security_group?ref=feat/module_eks"

  create_security_group = var.create_network_infrastructure
  name                  = "security-group-public-${var.name_prefix}"
  description           = "Security Group Public for ${var.name_prefix}"
  vpc_id                = module.aws_vpc.vpc_id
  ingress_rules         = var.security_group_public_ingress_rules
  egress_rules          = var.security_group_public_egress_rules

  tags = merge(var.eks_tags, {
    Name = "security-group-public-${var.name_prefix}"
  })

  depends_on = [module.aws_vpc]
}

#########################################
#                                       #
#         AWS Security Group            #
#                                       #
#########################################

module "aws_security_group_private" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_security_group?ref=feat/module_eks"

  create_security_group = var.create_network_infrastructure
  name                  = "security-group-private-${var.name_prefix}"
  description           = "Security Group Private for ${var.name_prefix}"
  vpc_id                = module.aws_vpc.vpc_id
  ingress_rules         = var.security_group_private_ingress_rules
  egress_rules          = var.security_group_private_egress_rules

  tags = merge(var.eks_tags, {
    Name = "security-group-private-${var.name_prefix}"
  })

  depends_on = [module.aws_vpc]
}

#########################################
#                                       #
#    AWS Security Group Databases       #
#                                       #
#########################################

module "aws_security_group_database" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_security_group?ref=feat/module_eks"

  create_security_group = var.create_network_infrastructure
  name                  = "security-group-database-${var.name_prefix}"
  description           = "Security Group for database in the cluster ${var.name_prefix}"
  vpc_id                = module.aws_vpc.vpc_id
  ingress_rules         = var.security_group_databases_ingress_rules
  egress_rules          = var.security_group_databases_egress_rules

  tags = merge(var.eks_tags, {
    Name = "security-group-database-${var.name_prefix}"
  })

  depends_on = [module.aws_vpc]
}

#########################################
#                                       #
#        AWS Route53 Zone Public        #
#                                       #
#########################################

module "aws_route53_zone_public" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_route53_zone?ref=feat/module_eks"

  create_route53_zone = var.create_network_infrastructure
  zone_name           = var.route53_zone_name
  vpc_id              = null
  tags = merge(var.eks_tags, {
    Name = "route53-zone-${var.name_prefix}"
  })

}

#########################################
#                                       #
#        AWS Route53 Zone Private       #
#                                       #
#########################################

module "aws_route53_zone_private" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_route53_zone?ref=feat/module_eks"

  create_route53_zone = var.create_network_infrastructure
  zone_name           = var.route53_zone_name
  vpc_id              = module.aws_vpc.vpc_id
  tags = merge(var.eks_tags, {
    Name = "route53-zone-${var.name_prefix}"
  })

  depends_on = [module.aws_vpc]
}


#########################################
#                                       #
#        AWS Elastic Cluster EKS        #
#                                       #
#########################################

module "aws_eks_cluster" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_eks_cluster?ref=feat/module_eks"

  create_aws_eks_cluster                    = var.create_aws_eks_cluster
  eks_cluster_name                          = var.eks_cluster_name
  eks_cluster_role_arn                      = data.aws_iam_role.eks_role.arn
  eks_cluster_net_config_service_ipv4_cidr  = var.eks_cluster_net_config_service_ipv4_cidr
  eks_cluster_net_config_ip_family          = var.eks_cluster_net_config_ip_family
  eks_cluster_vpc_config_subnet_ids         = module.aws_subnets_privates.private_subnets
  eks_cluster_vpc_config_security_group_ids = [module.aws_security_group_private.security_group_id]
  eks_cluster_endpoint_public_access        = var.eks_cluster_endpoint_public_access

  eks_cluster_tags = merge(var.eks_tags, {
    Name = "eks-cluster-${var.name_prefix}"
  })

  depends_on = [module.aws_security_group_private, module.aws_subnets_privates]
}

#########################################
#                                       #
#            AWS EKS Addon              #
#                                       #
#########################################
#
module "eks_cluster_addons" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_eks_addons?ref=feat/module_eks"

  create_aws_eks_addon = var.create_aws_eks_cluster

  eks_addons = {
    coredns = {
      cluster_name                = module.aws_eks_cluster.eks_cluster_name
      addon_name                  = "coredns"
      addon_version               = "v1.11.1-eksbuild.11"
      configuration_values        = ""
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    },
    kube-proxy = {
      cluster_name                = module.aws_eks_cluster.eks_cluster_name
      addon_name                  = "kube-proxy"
      addon_version               = "v1.30.3-eksbuild.2"
      configuration_values        = ""
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    },
    vpc-cni = {
      cluster_name                = module.aws_eks_cluster.eks_cluster_name
      addon_name                  = "vpc-cni"
      addon_version               = "v1.18.3-eksbuild.1"
      configuration_values        = ""
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
  }

  depends_on = [module.aws_eks_node_group]
}

#########################################
#                                       #
#        AWS EKS Node Group             #
#                                       #
#########################################

module "aws_eks_node_group" {
  source = "git::https://github.com/team-tech-challenge/terraform-modules-remotes.git//aws_eks_node_group?ref=feat/module_eks"

  create_node_group    = var.create_aws_eks_cluster
  cluster_name         = module.aws_eks_cluster.eks_cluster_name
  node_role_arn        = data.aws_iam_role.eks_role.arn
  subnet_ids           = module.aws_subnets_privates.private_subnets
  force_update_version = var.force_update_version
  disk_size            = var.disk_size

  desired_size   = var.scaling_desired_size
  max_size       = var.scaling_max_size
  min_size       = var.scaling_min_size
  instance_types = [var.instance_type]

  tags = merge(var.eks_tags, {
    Name = "eks-node-group-${var.name_prefix}"
  })

  depends_on = [module.aws_eks_cluster]
}
