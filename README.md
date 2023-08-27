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
8. Scroll down to Key pair, choose key or create a new one.
9. Scroll down to 'Resource tags' and modify the 'Name' tag. It's high recommended to concatenate your name (i.e: CSM-LAB-Jumper-James)
10. Click on 'Launch instance' orange button.
11. You should see a note like 'Successfully initiated launch of instance (i-xxxxxxxxxx)', click the link to move to ec2 instance page
12. Wait a few minutes for the instance to be available, locate your instance public ip.
13. Use pem file (ssh private key) from step #8, make sure to grant this file the right permissions (chmod 400 file.pem).
14. Connect to your jumper machine via: ssh -i "file.pem" centos@Your-Public-IP
15. Run the command ./run.sh

### Deploying EKS cluster with dih 16.2.1

1. cd OOTB-DIH-k8s-provisioning
2. Run: ./initGS-Lab.sh and follow the instructions
   ```
    If you encounter an error for missing jq run the following commands:
    # sudo yum install epel-release -y
    # sudo yum ypdate -y
    # sudo yum install jq -y
   ```



## Installing dih-umbrella when EKS is already available

1. cd scripts
2. Run ./install-dih-umbrella.sh


## Deploying data-feeder PU

1. Deploy a new space (with name: 'space')
> * using OPS-UI: On the left pane click 'Services'
> * Click the '+' sign on the upper right corner
> * Choose 'Deploy Space Service'
> * Enter service name: 'space'
> * Click Apply
2. Deploy a new feeder service
> * Download, from below url, the file data-feeder.jar to the local machine:
    https://github.com/GigaSpaces-ProfessionalServices/OOTB-DIH-k8s-provisioning/blob/main/jars/data-feeder.jar
> * using OPS-UI: On the left pane click 'Services'
> * Click the '+' sign on the upper right corner
> * Choose 'Deploy Stateless Service'
> * Enter service name: 'space-feeder'
> * For deployment type choose File and browse to the data-feeder.jar location 
> * Click Apply

------------------------------------------------------------------

### Purge k8s cluster, without deleting the EKS itself

1. cd scripts
2. Run ./uninstall-dih-umbrella.sh


### Deleting  EKS cluster

1. cd scripts
2. run ./destroy-eks-lab.sh
