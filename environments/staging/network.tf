module "network" {
  source                     = "../../modules/network"
  cidr_block                 = "10.0.0.0/16"
  vpc_name                   = "${var.infra_env}-ttomczyk-vpc"
  int_gateway_name           = "${var.infra_env}-ttomczyk-aws-int-gw"
  nat_gateway_name           = "${var.infra_env}-ttomczyk-aws-nat-gw"
  public_subnet1_name        = "${var.infra_env}-ttomczyk-tf-public-subnet1"
  public_subnet2_name        = "${var.infra_env}-ttomczyk-tf-public-subnet2"
  private_subnet1_name       = "${var.infra_env}-ttomczyk-tf-private-subnet1"
  private_subnet2_name       = "${var.infra_env}-ttomczyk-tf-private-subnet2"
  route_table_public_name    = "${var.infra_env}-ttomczyk-aws-route-table-public"
  route_table_private_name   = "${var.infra_env}-ttomczyk-aws-route-table-private"
  public_subnet1_cidr_block  = "10.0.32.0/22"
  subnet1_availability_zone  = "eu-west-1a"
  public_subnet2_cidr_block  = "10.0.36.0/22"
  subnet2_availability_zone  = "eu-west-1b"
  private_subnet1_cidr_block = "10.0.0.0/20"
  private_subnet2_cidr_block = "10.0.16.0/20"
}
