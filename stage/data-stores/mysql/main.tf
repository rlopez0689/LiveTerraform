provider "aws" { 
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-rlopez"
    key = "stage/mysql/terraform.tfstate"
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

resource "aws_subnet" "subnet"{
    count = "2"
    vpc_id     = "${aws_vpc.stage-vpc.id}"
    cidr_block = "${cidrsubnet(aws_vpc.stage-vpc.cidr_block, 8, count.index + 1)}"
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
}

resource "aws_db_subnet_group" "default"{
    name = "stage-db-subgroup"
    subnet_ids = ["${aws_subnet.subnet.*.id}"]
}

resource "aws_db_instance" "example" { 
    engine = "mysql"
    db_subnet_group_name = "${aws_db_subnet_group.default.name}"
    allocated_storage = 10 
    instance_class = "db.t2.micro"
    name = "stage_database"
    username = "admin"
    password = "${var.db_password}"
    skip_final_snapshot = true
}
