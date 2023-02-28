locals {
  primary = {
    region                         = "eu-west-1"
    name                           = "TF-CSM-LAB-Shmulik"
    ec2_profile                    = "wsus" # see the notes below
    Owner                          = "TF-CSM-LAB-Shmulik"
    ec2_image_id                   = "ami-04f5641b0d178a27a" #centos7.9
    ec2_win_image_id               = "ami-0604ab8d9bd0e2ab5" #Microsoft Windows Server 2019 Base
    ssh_key_name                   = "ssh-key-not-required"
    eks_worker-node-instance_type  = "t3a.large"
    ec2_linux_jumper_instance_type = "t3a.small"
    profile                        = "prod"
    eks_version                    = "1.21"

  }
  # AWS Auto shutdown policy
  # ------------------------
  # dsus - Auto shutdown at 08:00 PM EST daily.
  # dsil - Auto shutdown at 08:00 PM GMT+3 daily.
  # wsus - Auto shutdown at 08:00 PM EST every Friday.
  # wsil - Auto shutdown at 08:00 PM GMT+3 every Thursday.
  # prod - No auto shutdown.
}

