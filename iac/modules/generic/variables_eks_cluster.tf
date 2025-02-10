variable "create_aws_eks_cluster" {
  type        = bool
  description = "Create AWS EKS Cluster"
  default     = false
}

variable "create_aws_roles_to_cluster" {
  type        = bool
  description = "Create AWS Roles to Cluster"
  default     = false
}

variable "name_role_policy" {
  type        = string
  description = "Name of the role policy"
  default     = ""
}

variable "role_policy_statements" {
  type = list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  }))
  description = "Policy statements"
  default     = []
}

variable "description_role_policy" {
  type        = string
  description = "Description of the role policy"
  default     = ""
}

variable "force_detach_policies" {
  type        = bool
  description = "Force detach policies"
  default     = false
}

variable "service_eks_identifiers" {
  type        = list(string)
  description = "Service EKS Identifiers"
  default     = []
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = ""
}

variable "eks_cluster_net_config_service_ipv4_cidr" {
  type        = string
  description = "EKS Cluster Network Config Service IPv4 CIDR"
  default     = ""
}

variable "eks_cluster_net_config_ip_family" {
  type        = string
  description = "EKS Cluster Network Config IP Family"
  default     = ""
}

variable "eks_cluster_endpoint_public_access" {
  type        = bool
  description = "EKS Cluster Endpoint Public Access"
  default     = false
}

variable "scaling_desired_size" {
  type        = number
  description = "Scaling Desired Size"
  default     = 0
}

variable "scaling_max_size" {
  type        = number
  description = "Scaling Max Size"
  default     = 0
}

variable "scaling_min_size" {
  type        = number
  description = "Scaling Min Size"
  default     = 0
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
  default     = ""
}

variable "name_role_node_policy" {
  type        = string
  description = "Name of the node role policy"
  default     = ""
}

variable "description_node_role_policy" {
  type        = string
  description = "Description of the node role policy"
  default     = ""
}

variable "service_node_eks_identifiers" {
  type        = list(string)
  description = "Service Node Group Identifiers"
  default     = []
}

variable "node_role_policy_statements" {
  type = list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  }))
  description = "Policy node group statements"
  default     = []
}

variable "node_version" {
  type        = string
  description = "Version"
  default     = ""
}

variable "force_update_version" {
  type        = bool
  description = "Force Update Version"
  default     = false
}

variable "disk_size" {
  type        = number
  description = "Disk Size"
  default     = 20
}

variable "role_names" {
  type    = list(string)
  default = ["EMR_EC2_DefaultRole", "AWSServiceRoleForAmazonEKSNodegroup"]
}