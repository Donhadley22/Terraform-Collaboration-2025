variable "Cidr_block" {
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

variable "subnet_cidr_block" {
    type = string
    description = "CIDR block for the subnet"
}

variable "rt_name" {
  type = string
  description = "Route table name"
}

variable "gp_sbnet" {
  type = string
}

variable "rt_cidr_block" {
    type = string
    description = "CIDR block for the route table"
}