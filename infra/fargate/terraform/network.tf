data "aws_vpc" "selected"{
  id = var.vpc_id
}


resource "aws_ec2_transit_gateway" "my-test-tgw" {
  description                     = "my-test-transit-gateway"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

}

resource "aws_ec2_transit_gateway_vpc_attachment" "my-test-transit-gateway-attachment" {
  transit_gateway_id = "${aws_ec2_transit_gateway.my-test-tgw.id}"
  vpc_id             = "${var.vpc_id}"
  dns_support        = "enable"

  subnet_ids = data.aws_subnets.public.ids


}
resource "aws_route" "route" {
  count                  = var.rt_non_prod ? 1 : 0 
  gateway_id             = aws_ec2_transit_gateway.my-test-tgw.id
  route_table_id         = data.aws_vpc.selected.main_route_table_id
  destination_cidr_block = var.routetable_main_cidr_igw
}
