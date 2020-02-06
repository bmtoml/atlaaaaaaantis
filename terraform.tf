terraform { 
  backend "s3" {
    bucket = "poc-atlantis"
    key = "poc/default/terraform.tfstate"
    encrypt = true
  }
}
