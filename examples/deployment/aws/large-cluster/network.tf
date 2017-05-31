resource "aws_vpc" "butler" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "butler" {
  vpc_id = "${aws_vpc.butler.id}"
}

resource "aws_route" "internet_access" {
  route_table_id  = "${aws_vpc.butler.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.butler.id}"
}

resource "aws_subnet" "butler" {
  vpc_id = "${aws_vpc.butler.id}"
  cidr_block = "10.0.0.0/24"
}

