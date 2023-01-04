# # This scetion to allow user_data run awscli ec2 commands 
# resource "aws_iam_role" "awscli-role" {
#   name = "awscli-role-${local.primary.name}"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF

#   tags = {
#       tag-key = "TF-awscli-role-${local.primary.name}"
#   }
# }


# resource "aws_iam_policy" "awscli-update-kubeconfig-policy" {
#   name        = "awscli-update-kubeconfig-policy-${local.primary.name}"
#   description = "awscli-update-kubeconfig-policy-${local.primary.name}"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "eks:DescribeCluster",
#           "eks:ListClusters"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }


# resource "aws_iam_policy_attachment" "awscli-attach" {
#   name       = "awscli-attach-${local.primary.name}"
#   roles      = ["${aws_iam_role.awscli-role.name}"]
#   policy_arn = "${aws_iam_policy.awscli-update-kubeconfig-policy.arn}"
# }

# resource "aws_iam_instance_profile" "awscli-profile" {
#   name = "awscli-profile-${local.primary.name}"
#   role = "${aws_iam_role.awscli-role.name}"
# }

### EKS Role
resource "aws_iam_role" "primary-cluster" {
  name = "${local.primary.name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "primary-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.primary-cluster.name
}

resource "aws_iam_role_policy_attachment" "primary-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.primary-cluster.name
}

### Node Role
resource "aws_iam_role" "primary-node" {
  name = "${local.primary.name}-node"

  assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Effect    = "Allow"
                Sid       = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action    = "sts:AssumeRole"
            },
        ]
    })

    inline_policy {
        name   = "aws_ebs_csi"

        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {
                    Action = [
                        "ec2:CreateSnapshot",
                        "ec2:DeleteSnapshot",
                        "ec2:AttachVolume",
                        "ec2:DetachVolume",
                        "ec2:ModifyVolume",
                        "ec2:DescribeAvailabilityZones",
                        "ec2:DescribeInstances",
                        "ec2:DescribeSnapshots",
                        "ec2:DescribeTags",
                        "ec2:DescribeVolumes",
                        "ec2:DescribeVolumesModifications",
                        "ec2:CreateTags",
                        "ec2:DeleteTags",
                        "ec2:CreateVolume",
                        "ec2:DeleteVolume",
                        "ec2:DescribeLaunchTemplateVersions",
                        "autoscaling:DescribeAutoScalingGroups",
                        "autoscaling:DescribeAutoScalingInstances",
                        "autoscaling:DescribeLaunchConfigurations",
                        "autoscaling:DescribeTags",
                        "autoscaling:SetDesiredCapacity",
                        "autoscaling:TerminateInstanceInAutoScalingGroup",
                        "s3:ListAllMyBuckets",
                        "s3:ListBucket",
                        "s3:List*",
                        "s3:Get*"
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
        })
    }

    inline_policy {
        name = "aws_efs_csi"

        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action   = [
                        "elasticfilesystem:DescribeAccessPoints",
                        "elasticfilesystem:DescribeFileSystems",
                        "elasticfilesystem:CreateAccessPoint",
                        "elasticfilesystem:DeleteAccessPoint",
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
            ]
        })
    }
}

resource "aws_iam_role_policy_attachment" "primary-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.primary-node.name
}

resource "aws_iam_role_policy_attachment" "primary-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.primary-node.name
}

resource "aws_iam_role_policy_attachment" "primary-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.primary-node.name
}

resource "aws_iam_instance_profile" "eks-node-profile" {
    name       = "${local.primary.name}-eks-nodes-instance-profile"
    role       = aws_iam_role.primary-cluster.name
}