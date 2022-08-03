resource "aws_security_group" "sg_for_ec2" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
}