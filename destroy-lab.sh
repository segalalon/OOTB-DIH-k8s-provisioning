#!/bin/bash
terraform apply -destroy
rm -rf ./tmp terraform/terraform.tfstate*
