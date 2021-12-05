
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


resource aws_network_acl bastion {
  vpc_id = aws_default_vpc.main.id
}


resource aws_network_acl_rule bastion-ingress-0edef661 {
  network_acl_id = aws_network_acl.bastion.id
  egress         = false

  rule_number = "100"
  protocol    = "tcp"
  from_port   = "22"
  to_port     = "22"
  cidr_block  = "188.252.196.255/32"
  rule_action = "allow"
}

resource aws_network_acl_rule bastion-ingress-b9d232bf {
  network_acl_id = aws_network_acl.bastion.id
  egress         = false

  rule_number = "101"
  protocol    = "tcp"
  from_port   = "1024"
  to_port     = "65535"
  cidr_block  = "172.31.16.0/20"
  rule_action = "allow"
}

resource aws_network_acl_rule bastion-ingress-1c09fc57 {
  network_acl_id = aws_network_acl.bastion.id
  egress         = false

  rule_number = "103"
  protocol    = "tcp"
  from_port   = "1024"
  to_port     = "65535"
  cidr_block  = "172.31.0.0/20"
  rule_action = "allow"
}

resource aws_network_acl_rule bastion-ingress-45b22073 {
  network_acl_id = aws_network_acl.bastion.id
  egress         = false

  rule_number = "104"
  protocol    = "tcp"
  from_port   = "1024"
  to_port     = "65535"
  cidr_block  = "172.31.32.0/20"
  rule_action = "allow"
}



resource aws_network_acl_rule bastion-egress-a21a89f4 {
  network_acl_id = aws_network_acl.bastion.id
  egress         = true

  rule_number = "100"
  protocol    = "tcp"
  from_port   = "1024"
  to_port     = "65535"
  cidr_block  = "188.252.196.255/32"
  rule_action = "allow"
}

resource aws_network_acl_rule bastion-egress-cf1956c3 {
  network_acl_id = aws_network_acl.bastion.id
  egress         = true

  rule_number = "102"
  protocol    = "tcp"
  from_port   = "22"
  to_port     = "22"
  cidr_block  = "172.31.16.0/20"
  rule_action = "allow"
}

resource aws_network_acl_rule bastion-egress-3859b723 {
  network_acl_id = aws_network_acl.bastion.id
  egress         = true

  rule_number = "103"
  protocol    = "tcp"
  from_port   = "22"
  to_port     = "22"
  cidr_block  = "172.31.0.0/20"
  rule_action = "allow"
}

resource aws_network_acl_rule bastion-egress-18a50e0a {
  network_acl_id = aws_network_acl.bastion.id
  egress         = true

  rule_number = "104"
  protocol    = "tcp"
  from_port   = "22"
  to_port     = "22"
  cidr_block  = "172.31.32.0/20"
  rule_action = "allow"
}


