#!/bin/bash
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH
read -r -p "Do you want to destroy your EKS lab ?[y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        
        ;;
    *)
        echo "Aborted."
        exit
        ;;
esac
cd ../terraform
terraform plan -destroy -out destroy.out
terraform apply "destroy.out"

