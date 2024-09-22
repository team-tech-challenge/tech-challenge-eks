locals {
  tags = {
    Environment = var.workspace_environment
    Created_at  = formatdate("DD-MM-YYYY HH:mm:ss 'BRT'", timeadd(timestamp(), "-3h"))
    ManagedBy   = "Terraform"
    Service     = "ClusterEKS"
  }
}