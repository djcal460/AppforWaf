data "aws_vpc" "selected"{
  id = var.vpc_id
}
data "aws_internet_gateway" "IGW" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}
resource "aws_route" "route" {
  count                  = var.rt_non_prod ? 1 : 0 
  gateway_id             = data.aws_internet_gateway.IGW.id
  route_table_id         = data.aws_vpc.selected.main_route_table_id
  destination_cidr_block = var.routetable_main_cidr_igw
}
