resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private_route_table]
  nat_gateway_id         = var.natgw_id
}

/* route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.natgw_id
  }
*/
