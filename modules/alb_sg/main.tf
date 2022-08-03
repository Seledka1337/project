resource "aws_security_group" "sg_for_alb" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
}