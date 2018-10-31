provider "aws" { 
    region = "us-east-1"
}

terraform {
  backend "s3" {
    key = "stage/mysql/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

data "terraform_remote_state" "network" {
      backend = "s3"
      config {
        bucket = "${var.bucket_name}"
        key = "stage/network/terraform.tfstate"
        region = "us-east-1"
      } 
}

resource "aws_db_subnet_group" "default"{
    name = "stage-db-subgroup"
    subnet_ids = ["${data.terraform_remote_state.network.private_subnets}"]
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
