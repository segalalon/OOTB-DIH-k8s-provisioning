## OOTB-DIH-k8s-Provisioning

## Creating a Jumper machine

1. Login to AWS console
2. Select Irelan region
3. Select EC2 
4. Move to AMIs
5. Search for: AMI ID: ami-09008b9a6ec234ab8  (AMI NAME: CSM-Jumper-EKS)
6. Right-click "Launch instance from AMI"
7. Provide a Name
8. Click on Add addional tags and to add: Owner=xxx, Project=xxx and Profile=prod
9. Instance Type: t3a.medium
10. key pair name: OOTB-DIH-Provisioning
11. Click Launch and wait for the VM to be available.
12. Connect to the VM: ssh -i OOTB-DIH-Provisioning.pem centos@public-ip
13. chmod +x run.sh
14. ./run.sh (will pull the project from s3 and prepare it)
15. If you are requested to updatw AWS, cd OOTB-DIH-k8s-provisioning-main and update setAWSEnv.sh

### Deploying EKS cluster with dih 16.2.1

1. cd OOTB-DIH-k8s-provisioning-main
2. Update the AWS credentials in setAWSEnv.sh
3. Run ./initGS-Lab.sh and follow the instructions



## Installing dih-umbrella when EKS is already available

1. Run scripts/install-dih-umbrella.sh


## Deploying data-feeder PU

1. Deploy a new space (name space: 'space')
2. Deploy jars/data-feeder.jar

Note: You can deploy space and feeder using helm/ops-ui/rest

------------------------------------------------------------------

### Purge k8s cluster, without delteing the EKS itself

1. Run uninstall-dih-umbrella.sh


### Deleting  EKS cluster

1. Run scripts/scripts/destroy-eks-lab.sh


