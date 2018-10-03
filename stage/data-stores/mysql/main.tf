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

resource "aws_vpc" "stage-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main-db-1" {
  vpc_id     = "${aws_vpc.stage-vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "main-db-2" {
  vpc_id     = "${aws_vpc.stage-vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "default"{
    name = "main-db-subgroup"
    subnet_ids = ["${aws_subnet.main-db-1.id}", "${aws_subnet.main-db-2.id}"]
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
