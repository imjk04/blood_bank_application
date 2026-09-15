terraform {
  backend "s3" {
    bucket = "blood-bank-bucket-1509"
    key    = "Prod/terraform.tfstate"
    region = "us-east-2"
  }
}
