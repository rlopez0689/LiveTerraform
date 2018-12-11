provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    key     = "stage/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "webserver_cluster" {
  source                   = "git@github.com:rodrigolopez0689/TerraformModules.git//services/webserver-cluster?ref=v0.0.3"
  cluster_name             = "webservers-stage"
  remote_state_bucket      = "${var.bucket_name}"
  remote_state_db_key      = "stage/mysql/terraform.tfstate"
  remote_state_network_key = "stage/network/terraform.tfstate"
  server_port              = 80
  instance_type            = "t2.micro"
  route53_zone_id          = "${var.zone_id}"
  domain_name              = "${var.domain_name}"
  key_name                 = "RodAWS"
  min_size                 = 2
  max_size                 = 2
  weather_api_key          = "${var.weather_api_key}"
}
