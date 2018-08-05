variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "us-west-2"
}

variable "base_ami" {
  description = "link to CentOS7 base image in your region"
  default     = "ami-3ecc8f46"
}

variable "amount_of_nodes" {
  default = "3"
}

variable "vpc_id" {
  default = ""
}

variable "subnets" {
  description = "List of subnet IDs in different az's"
  type        = "list"
  default     = []
}

variable "external_storage_size" {
  description = "amount in Gb"
  default     = "1024"
}

variable "aws_ssh_key_name" {
  default = ""
}

variable "path_to_ssh_key" {
  description = "location of amazon ssh key at your machine"
  default     = ""
}

variable "dns_zone" {
  default = "test.com"
}

variable "mongo_image" {
  default = "vbobyr/aws_mongo_rs"
}
