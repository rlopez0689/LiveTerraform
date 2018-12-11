provider "aws" {
  region = "us-east-1"
}

variable "dynamo_table_name" {}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "${var.dynamo_table_name}"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
