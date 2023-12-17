# Restart dead or hung instance

resource "null_resource" "check_alarm_action" {
  count = local.instance_count

  triggers = {
    action = "arn:${data.aws_partition.default.partition}:swf:${local.region}:${data.aws_caller_identity.default.account_id}:${var.default_alarm_action}"
  }
}

