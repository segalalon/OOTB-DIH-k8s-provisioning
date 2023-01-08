## OOTB-DIH-k8s-Provisioning

### Prerequisties
* ssh key (OOTB-DIH-Provisioning.pem)
* AWS credentials

## Creating a Jumper machine

1. Login to AWS console
2. Select Ireland region (eu-west-1)
3. Select EC2 
4. Move to Instances page
5. On the top right corner click on the orange button (press the down arrow)
6. Click on 'Launch instance from template'
7. In Choose a launch template - search for 'CSM-LAB-EKS-JUMPER-template' (lt ID: lt-079d823907147c80b)
8. Scroll down to 'Resource tags' and modify the 'Name' tag. It's high recommended to concatenate your name (i.e: CSM-LAB-Jumper-James)
9. Click on 'Launch instance' orange button.
10. You should see a note like 'Successfully initiated launch of instance (i-xxxxxxxxxx)', click the link to move to ec2 instance page
11. Wait a few minutes for the instance to be available, locate your instance public ip.
12. Connect to your jumper machine via: ssh -i "OOTB-DIH-Provisioning.pem" centos@Your-Public-IP  (OOTB-DIH-Provisioning.pem will be provided by your lab admin)
13. Run the command ./run.sh and follow the instructions

### Deploying EKS cluster with dih 16.2.1

1. cd OOTB-DIH-k8s-provisioning-main
2. Update the AWS credentials in setAWSEnv.sh
3. Run ./initGS-Lab.sh and follow the instructions



## Installing dih-umbrella when EKS is already available

1. cd scripts
2. Run ./install-dih-umbrella.sh


## Deploying data-feeder PU

1. Deploy a new space (name space: 'space')
2. Deploy jars/data-feeder.jar

Note: You can deploy space and feeder using helm/ops-ui/rest

------------------------------------------------------------------

### Purge k8s cluster, without deleting the EKS itself

1. Run uninstall-dih-umbrella.sh


### Deleting  EKS cluster

1. cd scripts
2. run ./destroy-eks-lab.sh