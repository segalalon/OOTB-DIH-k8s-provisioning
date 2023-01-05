## OOTB-DIH-k8s-Provisioning

### Deploying EKS cluster with dih 16.2.1

1. Update the AWS credentials in setAWSEnv.sh
2. Run initGS-Lab.sh and follow the instructions


### Deleting  EKS cluster

1. Run scripts/scripts/destroy-eks-lab.sh


### Purge k8s cluster, without delteing the EKS itself

1. Run uninstall-dih-umbrella.sh


## Installing dih-umbrella when EKS is already available

1. Run scripts/install-dih-umbrella.sh


## Deploying data-feeder PU

1. Deploy a new space (name space: 'space')
2. Deploy jars/data-feeder.jar

Note: You can deploy space and feeder using helm/ops-ui/rest




