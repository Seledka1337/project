data "aws_availability_zones" "az" {
  state = "available"
  
}

resource "aws_subnet" "public_subnet" {
  count = length(var.cidr_block)
  availability_zone = count.index % 2 == 0 ? data.aws_availability_zones.az.names[0] : data.aws_availability_zones.az.names[1]
  vpc_id     = var.vpc_id
  map_public_ip_on_launch = true
  cidr_block = var.cidr_block[count.index]

  tags = {
    Name = "public_${count.index + 1}"
  }
}