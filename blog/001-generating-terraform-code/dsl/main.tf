
locals {
  public_ip = "188.252.196.255/32"
  subnet_a  = "172.31.16.0/20"
  subnet_b  = "172.31.0.0/20"
  subnet_c  = "172.31.32.0/20"

  bastion_in = [
    "from ${local.public_ip} to any port 22 proto tcp",
    "from ${local.subnet_a}  to any port 1024:65535 proto tcp",
    "from ${local.subnet_a}  to any port 1024:65535 proto tcp",
    "from ${local.subnet_b}  to any port 1024:65535 proto tcp",
  ]

  bastion_out = [
    "from any to ${local.public_ip} port 1024:65535 proto tcp",
    "from any to ${local.subnet_a}  port 22 proto tcp",
    "from any to ${local.subnet_b}  port 22 proto tcp",
    "from any to ${local.subnet_c}  port 22 proto tcp",
  ]
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "main" {
}

resource "aws_network_acl" "bastion" {
  vpc_id = aws_default_vpc.main.id
}

resource "aws_network_acl_rule" "bastion_in" {
  count          = length(local.bastion_in)
  network_acl_id = aws_network_acl.bastion.id
  egress         = false
  rule_number    = 100 + count.index + 1

  protocol   = element(split(" ", replace(trimspace(element(local.bastion_in, count.index)), "\\s+", "\\s", ), ), index(split(" ", replace(trimspace(element(local.bastion_in, count.index)), "\\s+", "\\s", ), ), "proto", ) + 1, )
  from_port  = element(split(":", element(split(" ", replace(trimspace(element(local.bastion_in, count.index)), "\\s+", "\\s", ), ), index(split(" ", replace(trimspace(element(local.bastion_in, count.index)), "\\s+", "\\s", ), ), "port", ) + 1, ), ), 0, )
  to_port    = element(split(":", element(split(" ", replace(trimspace(element(local.bastion_in, count.index)), "\\s+", "\\s", ), ), index(split(" ", replace(trimspace(element(local.bastion_in, count.index)), "\\s+", "\\s", ), ), "port", ) + 1, ), ), 1, )
  cidr_block = element(split(" ", replace(trimspace(element(local.bastion_in, count.index)), "\\s+", "\\s", ), ), index(split(" ", replace(trimspace(element(local.bastion_in, count.index)), "\\s+", "\\s", ), ), "from", ) + 1, )

  rule_action = "allow"
}

resource "aws_network_acl_rule" "bastion_out" {
  count          = length(local.bastion_out)
  network_acl_id = aws_network_acl.bastion.id
  egress         = true
  rule_number    = 100 + count.index + 1

  protocol   = element(split(" ", replace(trimspace(element(local.bastion_out, count.index)), "\\s+", "\\s", ), ), index(split(" ", replace(trimspace(element(local.bastion_out, count.index)), "\\s+", "\\s", ), ), "proto", ) + 1, )
  from_port  = element(split(":", element(split(" ", replace(trimspace(element(local.bastion_out, count.index)), "\\s+", "\\s", ), ), index(split(" ", replace(trimspace(element(local.bastion_out, count.index)), "\\s+", "\\s", ), ), "port", ) + 1, ), ), 0, )
  to_port    = element(split(":", element(split(" ", replace(trimspace(element(local.bastion_out, count.index)), "\\s+", "\\s", ), ), index(split(" ", replace(trimspace(element(local.bastion_out, count.index)), "\\s+", "\\s", ), ), "port", ) + 1, ), ), 1, )
  cidr_block = element(split(" ", replace(trimspace(element(local.bastion_out, count.index)), "\\s+", "\\s", ), ), index(split(" ", replace(trimspace(element(local.bastion_out, count.index)), "\\s+", "\\s", ), ), "to", ) + 1, )

  rule_action = "allow"
}
