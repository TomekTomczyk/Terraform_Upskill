resource "aws_iam_instance_profile" "ttomczyk_aws_iam_instance_profile" {
  name = "${var.infra_env}-ttomczyk_aws_iam_instance_profile"
  role = aws_iam_role.ttomczyk_aws_iam_role.name
}

resource "aws_autoscaling_group" "ttomczyk_aws_autoscaling_group" {
  name             = "${var.infra_env}-ttomczyk_aws_autoscaling_group"
  desired_capacity = 2
  min_size         = 2
  max_size         = 3
  vpc_zone_identifier = [module.network.public_subnet1_id, module.network.public_subnet2_id]

  launch_template {
    id      = aws_launch_template.ttomczyk_aws_launch_template.id
    version = aws_launch_template.ttomczyk_aws_launch_template.latest_version
  }
}

resource "aws_launch_template" "ttomczyk_aws_launch_template" {
  name                   = "ttomczyk_aws_launch_template"
  instance_type          = var.instance_type
  image_id               = data.aws_ami.ami.id
  ebs_optimized          = true
  vpc_security_group_ids = [aws_security_group.ttomczyk_ec2_security_group.id]

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ttomczyk_aws_iam_instance_profile.arn
  }

  tag_specifications {
    resource_type = "instance"
    tags          = {
      Name   = "${var.infra_env}-ttomczyk_aws_launch_template"
      Source = "Autoscaling"
    }
  }
}
