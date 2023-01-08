#!/bin/bash
source ../setAWSEnv.sh
./uninstall-dih-umbrella.sh
cd ../terraform
terraform apply -destroy

