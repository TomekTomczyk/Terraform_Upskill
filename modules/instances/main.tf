resource "aws_instance" "aws_instance_template" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = var.subnet_id

  tags = {
    Name  = var.instance_name
    Owner = "ttomczyk"
  }
}
