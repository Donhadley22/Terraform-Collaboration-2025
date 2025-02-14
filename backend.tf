terraform {
  backend "s3" {
    bucket = "caleb-victor-backend-2025"
    key    = "devops/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "caleb-victor-backend-2025"
  }
}
