variable "vpc_cidr_block" {
    type = string
    description = "CIDR block for the VPC"
}

variable "VPC_Name" {
  type = string
  description = "Name of the VPC"
}

variable "gp_gw" {
  type = string
  description = "Internet gateway"
}

