#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "primary-node" {
  name = "${local.primary.name}-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "primary-node-PolicyAutoScaling" {
  name = "eks-nodegroup-ng-maneksami2-PolicyAutoScaling"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeTags",
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup",
            "ec2:DescribeLaunchTemplateVersions",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.primary-node.name
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

resource "aws_iam_role_policy_attachment" "primary-node-Amazon-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.primary-node.name
}


resource "aws_launch_template" "primary" {
  instance_type = local.primary.eks_worker-node-instance_type
  name          = format("at-lt-%s-node", aws_eks_cluster.primary.name)
  tags          = {
    Owner   = "${local.primary.Owner}"
    Project = "${local.primary.name}"
    profile = local.primary.profile
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = format("%s-node", aws_eks_cluster.primary.name)
      Owner   = "${local.primary.Owner}"
      Project = "${local.primary.name}"
      profile = local.primary.profile
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_eks_node_group" "primary" {
  cluster_name    = aws_eks_cluster.primary.name
  node_group_name = "${local.primary.name}-node-group"
  node_role_arn   = aws_iam_role.primary-node.arn
  subnet_ids      = aws_subnet.primary[*].id
  instance_types  = []

  launch_template {
    name    = aws_launch_template.primary.name
    version = "1"
  }

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 0
  }


  depends_on = [
    aws_iam_role_policy_attachment.primary-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.primary-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.primary-node-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name    = "${local.primary.name}-node-group"
    Owner   = "${local.primary.Owner}"
    Project = "${local.primary.name}"
    profile = local.primary.profile
  }
}
