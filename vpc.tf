# Internet VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "UAT-terraform"
    }
}

# Subnets
resource "aws_subnet" "uat-public-1a" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"

    tags {
        Name = "uat-public-1a"
    }
}
resource "aws_subnet" "uat-public-1c" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1c"

    tags {
        Name = "uat-public-1c"
    }
}

resource "aws_subnet" "uat-private-1b" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.7.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"

    tags {
        Name = "uat-private-1b"
    }
}
resource "aws_subnet" "uat-private-1d" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.8.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1d"

    tags {
        Name = "uat-private-1d"
    }
}

# Internet GW
resource "aws_internet_gateway" "uat-gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "uat-gw"
    }
}

# route tables
resource "aws_route_table" "uat-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.uat-gw.id}"
    }

    tags {
        Name = "uat-public"
    }
}

# route associations public
resource "aws_route_table_association" "uat-public-1a" {
    subnet_id = "${aws_subnet.uat-public-1a.id}"
    route_table_id = "${aws_route_table.uat-public.id}"
}
resource "aws_route_table_association" "uat-public-1c" {
    subnet_id = "${aws_subnet.uat-public-1c.id}"
    route_table_id = "${aws_route_table.uat-public.id}"
}
