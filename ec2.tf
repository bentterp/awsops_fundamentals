resource "aws_instance" "cloudfarm" {
  ami           = "ami-57108238"
  instance_type = "t2.micro"
	vpc_security_group_ids = [ "${aws_security_group.cloudfarm.id}" ]
	subnet_id = "${module.vpc.public_subnets[0]}"
	root_block_device {
		volume_type           = "gp2"
		volume_size           = 8
		delete_on_termination = true
	}
	tags {
    "Name"           = "CloudFarm ${title(var.environment)}"
    "CostCenter"     = "${var.costcenter}"
    "Environment"    = "${var.environment}"
  }
}

output "cloudhostname" {
	description = "Hostname of the Cloudfarm server"
	value       = "${aws_instance.cloudfarm.public_dns}"
}