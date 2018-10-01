resource "aws_s3_bucket" "terraform_state"{
    bucket = "terraform-state-rl"
    force_destroy = true
    
    versioning {
        enabled = true
    }

    lifecycle{
        prevent_destroy = true
    }
}
