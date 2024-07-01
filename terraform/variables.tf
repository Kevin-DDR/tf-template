variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "S3_NAME" {
  type    = string
  default = "tf-template-bucket"
}

variable "domain_name" {
  default = "kddr.fr"
}

variable "subdomain_name" {
  default = "tf-template"
}

# locals {
#   envs = { for tuple in regexall("(.*)=(.*)", file("../.env")) : tuple[0] => sensitive(tuple[1]) }
# }

variable "APPLICATION_KEY" {
  sensitive = true
  type      = string
}

variable "APPLICATION_SECRET" {
  sensitive = true
  type      = string
}

variable "CONSUMER_KEY" {
  sensitive = true
  type      = string
}
