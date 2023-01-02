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

resource "aws_security_group" "primary-cluster" {
  name        = "${local.primary.name}"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.primary.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.primary.name}-sg"
  }
}

resource "aws_security_group_rule" "primary-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.primary-cluster.id}"
  source_security_group_id = "${aws_security_group.primary-cluster.id}"
  to_port                  = 443
  type                     = "ingress"
}
resource "aws_security_group_rule" "demo-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.primary-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "primary" {
  name     = "${local.primary.name}"
  role_arn = aws_iam_role.primary-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.primary-cluster.id]
    subnet_ids         = aws_subnet.primary[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.primary-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.primary-cluster-AmazonEKSServicePolicy,
  ]
}

output "eks-cluster-name" {
  value = aws_eks_cluster.primary.*.name
}