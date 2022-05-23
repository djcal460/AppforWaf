data "aws_vpc" "selected"{
  id = var.vpc_id
}
data "aws_ec2_transit_gateway" "my-test-tgw" {
  description                     = "my-test-transit-gateway"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  tags {
    Name = "my-test-transit-gateway"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "my-test-transit-gateway-attachment" {
  transit_gateway_id = data.aws_ec2_transit_gateway.my-test-tgw
  vpc_id             = data.aws_vpc.selected.id
  dns_support        = "enable"

  subnet_ids = [[data.aws_subnet_ids.public.ids]]

  tags {
    Name = "my-test-tgw-vpc-attachment"
  }
}

resource "aws_route" "route" {
  count                  = var.rt_non_prod ? 1 : 0 
  gateway_id             = data.aws_ec2_transit_gateway.my-test-tgw.id
  route_table_id         = data.aws_vpc.selected.main_route_table_id
  destination_cidr_block = var.routetable_main_cidr_igw
}

resource "aws_route" "my-tgw-route" {
  route_table_id         = data.aws_vpc.selected.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.my-test-tgw
}
