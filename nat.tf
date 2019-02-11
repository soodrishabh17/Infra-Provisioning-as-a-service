# nat gw
resource "aws_eip" "nat" {
  vpc      = true
}
resource "aws_nat_gateway" "uat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.uat-public-1a.id}"
  depends_on = ["aws_internet_gateway.uat-gw"]
}

# VPC setup for NAT
resource "aws_route_table" "uat-private" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.uat-gw.id}"
    }

    tags {
        Name = "uat-private"
    }
}
# route associations private
resource "aws_route_table_association" "uat-private-1b" {
    subnet_id = "${aws_subnet.uat-private-1b.id}"
    route_table_id = "${aws_route_table.uat-private.id}"
}
resource "aws_route_table_association" "uat-private-1d" {
    subnet_id = "${aws_subnet.uat-private-1d.id}"
    route_table_id = "${aws_route_table.uat-private.id}"
}
