variable "name" {
  type    = string
  default = "dev-tools-day4"
}

locals {
  ami_id        = "ami-0f511ead81ccde020"
  instance_type = "t2.micro"
}

variable "local_ip" {
  type = string
  default = "180.129.98.78" # http://ipv4.icanhazip.com/
}

# https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/examples/complete
#############################################################
# Data sources to get VPC and default security group details
#############################################################
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "devtools4" {
  name   = "devtools4"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"

  cidr_blocks       = ["${var.local_ip}/32"]
  security_group_id = aws_security_group.devtools4.id
}

resource "aws_instance" "app_server_4" {
  ami           = local.ami_id
  instance_type = local.instance_type

  tags = {
    Name = var.name
  }

  vpc_security_group_ids = [aws_security_group.devtools4.id]
  key_name = "devtools4"
}

output "instance_ip" {
  value = aws_instance.app_server_4.public_ip
}

output "instance_id" {
  value = aws_instance.app_server_4.id
}