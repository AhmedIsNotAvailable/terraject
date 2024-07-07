
variable "region" {
  type = "string"
  default = "us-east-2"
  description = "region set to: ohio"
}


variable "cidr_block" {
  type = "string"
  default = "10.0.0.0/16"
  description = "cidr block with 6k subnets"
}

variable "public_subnets" {
  type = list(string)
  default = [] 
  description = "public nets from tfvars"
}

variable "private_subnets" {
  type = list(string)
  default = []
  description = "public nets from tfvars"

}

variable "azs" {
    type = list(string)
    default = []
    description = "azs in tfvars"
  
}