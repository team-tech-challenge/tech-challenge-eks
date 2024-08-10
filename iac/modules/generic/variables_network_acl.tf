variable "public_network_acl_ingress_rules" {
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
    icmp_type  = optional(number)
    icmp_code  = optional(number)
  }))
  default = []
}

variable "public_network_acl_egress_rules" {
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
    icmp_type  = optional(number)
    icmp_code  = optional(number)
  }))
  default = []
}

variable "private_network_acl_ingress_rules" {
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
    icmp_type  = optional(number)
    icmp_code  = optional(number)
  }))
  default = []
}

variable "private_network_acl_egress_rules" {
  type = list(object({
    protocol   = string
    rule_no    = number
    action     = string
    cidr_block = string
    from_port  = number
    to_port    = number
    icmp_type  = optional(number)
    icmp_code  = optional(number)
  }))
  default = []
}