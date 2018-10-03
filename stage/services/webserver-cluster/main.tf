provider "aws" { 
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "terraform-state-rlopez"
    key     = "stage/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}


module "webserver_cluster" {
    source = "git@github.com:rodrigolopez0689/TerraformModules.git//services/webserver-cluster?ref=v0.0.1"
    cluster_name = "webservers-stage"
    remote_state_bucket = "terraform-state-rlopez"
    remote_state_key = "stage/mysql/terraform.tfstate"
    server_port = 8080
    instance_type = "t2.micro"
    min_size = 2
    max_size = 2
}
