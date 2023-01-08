## OOTB-DIH-k8s-Provisioning

## Creating a Jumper machine

1. Login to AWS console
2. Select Ireland region (eu-west-1)
3. Select EC2 
4. Move to Instances page
5. On the top right corner click on the orange button (down arrow)
6. 
7. Right-click "Launch instance from AMI"
8. Provide a Name
9. Click on Add addional tags and to add: Owner=xxx, Project=xxx and Profile=prod
10. Instance Type: t3a.medium
11. key pair name: OOTB-DIH-Provisioning
12. Click Launch and wait for the VM to be available.
13. Connect to the VM: ssh -i OOTB-DIH-Provisioning.pem centos@public-ip
14. chmod +x run.sh
15. ./run.sh (will pull the project from s3 and prepare it)
16. If you are requested to updatw AWS, cd OOTB-DIH-k8s-provisioning-main and update setAWSEnv.sh

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


