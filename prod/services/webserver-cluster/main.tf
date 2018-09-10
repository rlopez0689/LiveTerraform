provider "aws" { 
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "terraform-up-and-running-state-rl"
    key     = "prod/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

module "webserver_cluster" {
    source = "git@github.com:rodrigolopez0689/TerraformModules.git//services/webserver-cluster?ref=v0.0.1"
    cluster_name = "webservers-prod"
    remote_state_bucket = "terraform-up-and-running-state-rl"
    remote_state_key = "prod/mysql/terraform.tfstate"
    server_port = 8080
    instance_type = "t2.small"
    min_size = 2
    max_size = 4
}
