provider "aws" { 
    region = "us-east-1"
}

terraform {
  backend "s3" {
    key = "prod/mysql/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

data "terraform_remote_state" "network"{
    backend = "s3"
    config {
        bucket = "${var.bucket_name}"
        key = "prod/network/terraform.tfstate"
        region = "us-east-1"
    }
}

resource "aws_security_group" "db" {
  vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.network.public_subnets_cidr}"]
  }
}

resource "aws_db_subnet_group" "default"{
    name = "prod-db-subgroup"
    subnet_ids = ["${data.terraform_remote_state.network.private_subnets}"]
}

resource "aws_db_instance" "weatherdb" { 
    engine = "postgres"
    db_subnet_group_name = "${aws_db_subnet_group.default.name}"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    allocated_storage = 10 
    instance_class = "db.t2.micro"
    name = "weatherdb"
    username = "weatheruser"
    password = "${var.db_password}"
    skip_final_snapshot = true
}
