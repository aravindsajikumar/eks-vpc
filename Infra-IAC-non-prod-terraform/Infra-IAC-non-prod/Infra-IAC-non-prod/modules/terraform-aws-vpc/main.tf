locals {
  enabled                                         = module.this.enabled
  enable_default_security_group_with_custom_rules = var.enable_default_security_group_with_custom_rules && local.enabled ? 1 : 0
  enable_internet_gateway                         = var.enable_internet_gateway && local.enabled ? 1 : 0
}


module "label" {
  source = "../terraform-null-label"

  context = module.this.context
}

resource "aws_vpc" "default" {
  count                            = local.enabled ? 1 : 0
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  #enable_classiclink               = var.enable_classiclink
  #enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = true
  tags                             = module.label.tags
}

# If `aws_default_security_group` is not defined, it would be created implicitly with access `0.0.0.0/0`
resource "aws_default_security_group" "default" {
  count  = local.enable_default_security_group_with_custom_rules
  vpc_id = join("", aws_vpc.default.*.id)

  tags = merge(module.label.tags, { Name = "Default Security Group" })
}


resource "aws_security_group_rule" "default" {
  count             = local.enabled ? local.enable_default_security_group_with_custom_rules : 0
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_default_security_group.default.*.id)
  type              = "egress"
}


resource "aws_security_group_rule" "default1" {
  count             = local.enabled ? local.enable_default_security_group_with_custom_rules : 0
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [join("", aws_vpc.default.*.cidr_block)]
  security_group_id = join("", aws_default_security_group.default.*.id)
  type              = "ingress"
}


resource "aws_internet_gateway" "default" {
  count  = local.enable_internet_gateway
  vpc_id = join("", aws_vpc.default.*.id)
  tags   = module.label.tags
}
