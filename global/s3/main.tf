provider "aws" { 
    region = "us-east-1"
}

variable "bucket_name"{}

resource "aws_s3_bucket" "terraform_state"{
    bucket = "${var.bucket_name}"
    force_destroy = true
    
    versioning {
        enabled = true
    }

#    lifecycle{
#        prevent_destroy = true
#    }
}
