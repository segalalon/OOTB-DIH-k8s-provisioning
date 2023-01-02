provider "aws" {
  region = local.primary.region
}

data "aws_availability_zones" "available" {}
