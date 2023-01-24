resource "aws_iam_role" "ttomczyk_aws_iam_role" {
  name               = "${var.infra_env}_ttomczyk_aws_iam_role"
  assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }
      ]
    })

  tags = {
    Name = "ttomczyk-aws-iam-role"
    Env  = var.infra_env
  }
}

resource "aws_iam_role_policy_attachment" "resources-ssm-policy" {
  role       = aws_iam_role.ttomczyk_aws_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
