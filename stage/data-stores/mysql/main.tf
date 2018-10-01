provider "aws" { 
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-rl"
    key = "stage/mysql/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}
resource "aws_db_instance" "example" { 
    engine = "mysql"
    allocated_storage = 10 
    instance_class = "db.t2.micro"
    name = "stage_database"
    username = "admin"
    password = "${var.db_password}"
    skip_final_snapshot = true
}
