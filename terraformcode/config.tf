terraform {
  backend "s3" {
    bucket = "assignment1-sweta"             // Bucket where to SAVE Terraform State
    key    = "assignment1/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                     // Region where bucket is created
  }
}