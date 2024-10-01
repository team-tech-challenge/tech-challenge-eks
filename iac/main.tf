module "cluster_eks" {
  source                        = "./modules/generic"
  create_network_infrastructure = true

  # Initial Configuration
  name_prefix       = "tech-challenge"
  route53_zone_name = "techchallenge.com.br"
  eks_tags          = local.tags

  # VPC Configuration
  cidr_block = "172.18.0.0/20"

  # Subnets Configuration
  public_subnets = [
    "172.18.0.0/25",
    "172.18.0.128/25",
  ]
  private_subnets = [
    "172.18.2.0/23",
    "172.18.4.0/23",
  ]

  # Network ACL Configuration Public - Ingess
  public_network_acl_ingress_rules = [
    {
      protocol   = "-1"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]

  # Network ACL Configuration Public - Egress
  public_network_acl_egress_rules = [
    {
      protocol   = "-1"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]

  # Network ACL Configuration Private - Ingress
  private_network_acl_ingress_rules = [
    {
      protocol    = "-1"
      rule_no     = 100
      action      = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
      description = "Allow Kubernetes API server"
    }
  ]

  # Network ACL Configuration Private - Egress
  private_network_acl_egress_rules = [
    {
      protocol   = "-1"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]

  # Security Groups Public - Inbound rules
  security_group_public_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP connections"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS connections"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DNS (TCP)"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DNS (UDP)"
    }
  ]

  # Security Groups Public - Outbound rules
  security_group_public_egress_rules = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all TCP connections to external destinations"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DNS (TCP)"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DNS (UDP)"
    }
  ]

  # Security Groups Private - Inbound rules
  security_group_private_ingress_rules = [
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow Kubernetes API server"
    },
    {
      from_port   = 2379
      to_port     = 2380
      protocol    = "tcp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow etcd server client API"
    },
    {
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow Kubelet API"
    },
    {
      from_port   = 10259
      to_port     = 10259
      protocol    = "tcp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow kube-scheduler"
    },
    {
      from_port   = 10257
      to_port     = 10257
      protocol    = "tcp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow kube-controller-manager"
    },
    {
      from_port   = 10256
      to_port     = 10256
      protocol    = "tcp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow kube-proxy"
    },
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow NodePort Services"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow DNS (TCP)"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["172.18.0.0/20"]
      description = "Allow DNS (UDP)"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS connections"
    }
  ]

  # Security Groups Private - Outbound rules
  security_group_private_egress_rules = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all TCP connections to external destinations"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DNS (TCP)"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow DNS (UDP)"
    }
  ]

  # EKS Cluster
  create_aws_eks_cluster                   = true
  eks_cluster_name                         = "cluster-tech-challenge"
  eks_cluster_net_config_service_ipv4_cidr = "10.100.0.0/20"
  eks_cluster_net_config_ip_family         = "ipv4"
  eks_cluster_endpoint_public_access       = true

  # EKS Node Group
  scaling_desired_size = 2
  scaling_max_size     = 2
  scaling_min_size     = 2
  instance_type        = "t3.large"
  force_update_version = true
  disk_size            = 70
}