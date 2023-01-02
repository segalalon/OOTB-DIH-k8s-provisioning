# This scetion to allow user_data run awscli ec2 commands 
resource "aws_iam_role" "awscli-role" {
  name = "awscli-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "TF-awscli-role"
  }
}


resource "aws_iam_policy" "awscli-update-kubeconfig-policy" {
  name        = "awscli-update-kubeconfig-policy"
  description = "awscli-update-kubeconfig-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_policy_attachment" "awscli-attach" {
  name       = "awscli-attach"
  roles      = ["${aws_iam_role.awscli-role.name}"]
  policy_arn = "${aws_iam_policy.awscli-update-kubeconfig-policy.arn}"
}

resource "aws_iam_instance_profile" "awscli-profile" {
  name = "awscli-profile"
  role = "${aws_iam_role.awscli-role.name}"
}

