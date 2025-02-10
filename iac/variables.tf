variable "workspace_environment" {
  description = "The environment where the resources will be created.OPTIONS: dev, stg, prd"
  type        = string
  default     = "production"
}