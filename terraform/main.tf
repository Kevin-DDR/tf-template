terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34"
    }
    ovh = {
      source = "ovh/ovh"
    }
  }

  required_version = ">= 1.2.0"

}


provider "aws" {
  region = "eu-west-3"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.APPLICATION_KEY
  application_secret = var.APPLICATION_SECRET
  consumer_key       = var.CONSUMER_KEY
}