terraform {
  backend "s3" {
    bucket = "terraform-buck-2025"
    key    = "devops/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-lock-table"
    role_arn = "arn:aws:iam::067188631142:user/Donhadley"
  }
}
