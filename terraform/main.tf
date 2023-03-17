module "primary_site" {
  source         = "./primary_site"
  vpc_cidr = "10.0.0.0/16"
  subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
 
}

terraform {
  backend "s3" {
    bucket = "csm-training"
    #key    = "OOTB-DIH-k8s-provisioning/Terraform-State-files"
    region = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}