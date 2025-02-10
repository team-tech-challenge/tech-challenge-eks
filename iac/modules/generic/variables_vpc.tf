variable "create_network_infrastructure" {
  description = "Create the network infrastructure"
  type        = bool
  default     = false
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "dns_support" {
  description = "Enable DNS support"
  type        = bool
  default     = true
}

variable "dns_hostnames" {
  description = "Enable DNS hostnames"
  type        = bool
  default     = true
}

variable "eks_tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

