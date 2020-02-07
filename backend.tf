terraform {
  backend "s3" {
    bucket = "poc-atlantis"
    key    = "poc/default/terraform.tfstate"
    region = "eu-west-1"
    encrypt = "true"
  }
}
