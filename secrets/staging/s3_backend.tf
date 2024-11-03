terraform {
  backend "s3" {
    bucket         = "your-state-s3-bucket"
    key            = "statefiles/URLShortener/staging-env.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}