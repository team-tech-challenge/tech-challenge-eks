data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}


data "aws_iam_role" "eks_role" {
  name = "LabRole"
}