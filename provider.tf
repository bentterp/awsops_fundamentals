terraform {
  required_version = "~> 0.11.1"
	backend "s3" {
		role_arn     = "arn:aws:iam::552687213402:role/admin"
		external_id  = "BF-AWSOpsLab"
		bucket         = "bf-awslab-tfstate"
		key            = "fundamentals/####.tfstate"
		dynamodb_table = "TerraformLocks"
		region         = "eu-west-1"
	}
}
provider "aws" {
	version = "~> 1.12"
	region  = "${var.region}"
	assume_role {
		role_arn     = "arn:aws:iam::552687213402:role/admin"
		external_id  = "BF-AWSOpsLab"
	}
}
