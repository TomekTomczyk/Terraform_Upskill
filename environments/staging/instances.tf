module "aws_instance1" {
  source                 = "../../modules/instances"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ttomczyk_ec2_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.ttomczyk_aws_iam_instance_profile.name
  subnet_id              = module.network.public_subnet1_id
  instance_name          = "${var.infra_env}-ttomczyk-ecs-instance1"
}

module "aws_instance2" {
  source                 = "../../modules/instances"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ttomczyk_ec2_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.ttomczyk_aws_iam_instance_profile.name
  subnet_id              = module.network.public_subnet2_id
  instance_name          = "${var.infra_env}-ttomczyk-ecs-instance2"
}

resource "aws_iam_instance_profile" "ttomczyk_aws_iam_instance_profile" {
  name = "${var.infra_env}-ttomczyk_aws_iam_instance_profile"
  role = aws_iam_role.ttomczyk_aws_iam_role.name
}
