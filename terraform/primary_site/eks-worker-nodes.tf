
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

