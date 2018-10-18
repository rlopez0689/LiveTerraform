provider "aws" { 
    region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state"{
    bucket = "terraform-state-rlopez"
    force_destroy = true
    
    versioning {
        enabled = true
    }

    lifecycle{
        prevent_destroy = true
    }
}
