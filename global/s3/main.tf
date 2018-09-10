resource "aws_s3_bucket" "terraform_state"{
    bucket = "terraform-up-and-running-state-rl"
    
    versioning {
        enabled = true
    }

    lifecycle{
        prevent_destroy = true
    }
}