provider "aws" { 
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-rlopez"
    key = "prod/mysql/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

data "terraform_remote_state" "network"{
    backend = "s3"
    config {
        bucket = "terraform-state-rlopez"
        key = "prod/network/terraform.tfstate"
        region = "us-east-1"
    }
}

resource "aws_db_subnet_group" "default"{
    name = "prod-db-subgroup"
    subnet_ids = ["${data.terraform_remote_state.network.private_subnets}"]
}

resource "aws_db_instance" "example" { 
    engine = "mysql"
    db_subnet_group_name = "${aws_db_subnet_group.default.name}"
    allocated_storage = 10 
    instance_class = "db.t2.micro"
    name = "example_database"
    username = "admin"
    password = "${var.db_password}"
    skip_final_snapshot = true
}
