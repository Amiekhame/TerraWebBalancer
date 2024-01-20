terraform {
    backend "s3" {
        bucket = "oshobuckett"
        key    = "exec/terraform.tfstate"
        region = "us-east-1"
    }
}