module "cluster_eks" {
  source      = "./modules/generic"
  name_prefix = "eks-prd-tech"
  cidr_block  = "172.18.0.0/20"
  public_subnets = [
    "172.18.0.0/24",
    "172.18.1.0/24",
  ]
  private_subnets = [
    "172.18.10.0/24",
    "172.18.11.0/24",
  ]
  public_network_acl_ingress_rules = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
  ]
  public_network_acl_egress_rules = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
  ]
  private_network_acl_ingress_rules = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
  ]
  private_network_acl_egress_rules = [
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
  ]

  eks_tags                      = local.tags
  create_network_infrastructure = true
}