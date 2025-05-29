terraform {
  backend "s3" {
    bucket = "terraform-buck-2025"
    key    = "devops/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}
