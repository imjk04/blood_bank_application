terraform {
  backend "s3" {
    bucket = "blood-bank-bucket-1510"
    key    = "Prod/terraform.tfstate"
    region = "us-east-2"
  }
}
