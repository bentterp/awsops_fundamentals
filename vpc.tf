module "vpc" {
  source             = "git@github.com:basefarm/bf_aws_mod_vpc"
  name               = "${var.environment}"
  cidr               = "10.0.0.0/16"
  azs                = [ "eu-central-1a", "eu-central-1b" ]
  public_subnets     = [ "10.0.101.0/24", "10.0.102.0/24" ]
  create_nat_gateway = "true"
  create_vgw         = "true"
  flowlogs_s3_bucket = "cloudfarm-${var.environment}-flowlogs"
  tags {
    "CostCenter"     = "${var.costcenter}"
    "Environment"    = "${var.environment}"
  }
}

resource "aws_s3_bucket" "flowlogs" {
  bucket         = "cloudfarm-${var.environment}-flowlogs"
  acl            = "private"
  force_destroy = true
  tags {
    Name             = "Flowlogs ${title(var.environment)}"
    "CostCenter"     = "${var.costcenter}"
    "Environment"    = "${var.environment}"
  }
}
resource "aws_security_group" "cloudfarm" {
  name        = "${var.environment}-cloudfarm"
  description = "${var.environment}s personal CloudFarm security group"
  vpc_id      = "${module.vpc.vpc_id}"
}
resource "aws_security_group_rule" "allow_http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["85.166.234.146/32"]
  security_group_id = "${aws_security_group.cloudfarm.id}"
}

