resource "aws_nat_gateway" "nat_gtw" {
  allocation_id = aws_eip.natgtw_eip.id
  subnet_id     = var.subnet_id

  tags = {
    Name = "project nat"
  }

  depends_on = [
    aws_eip.natgtw_eip
  ]
}

resource "aws_eip" "natgtw_eip" {
    vpc = true

    tags = {
      Name = "project_eip"
    }
  
}