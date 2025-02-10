variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  sensitive   = true
  default     = []
}


variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  sensitive   = true
  default     = []
}
