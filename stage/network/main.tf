provider "aws" { 
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-rlopez"
    key = "stage/network/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "stage-vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags {
    Name = "stage-vpc"
  }
}

resource "aws_subnet" "subnets"{
    count = "4"
    vpc_id     = "${aws_vpc.stage-vpc.id}"
    cidr_block = "${cidrsubnet(aws_vpc.stage-vpc.cidr_block, 8, count.index + 1)}"
    availability_zone = "${data.aws_availability_zones.available.names[(count.index % 2)]}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.stage-vpc.id}"
}

resource "aws_route_table" "route_public_subnet" {
  vpc_id = "${aws_vpc.stage-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "subnets"{
    count = "2"
    subnet_id = "${element(aws_subnet.subnets.*.id, count.index + 2)}"
    route_table_id = "${aws_route_table.route_public_subnet.id}"
}
