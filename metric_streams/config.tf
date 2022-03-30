resource "aws_config_configuration_recorder" "configuration_recorder" {
  name = "metric-stream-config"
  recording_group {
    all_supported = true
  }
  role_arn = aws_iam_role.config.arn
}

resource "aws_iam_role" "config" {
  name               = "metric-stream-config"
  description        = "Role to allow Config Service communicate with Delivery Channel"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.config_assume.json
}

data "aws_iam_policy_document" "config_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["config.amazonaws.com"]
      type        = "Service"
    }
  }
  version = "2012-10-17"
}

resource "aws_iam_role_policy" "config_s3_access" {
  name   = "config-s3-access"
  policy = data.aws_iam_policy_document.config_s3_access.json
  role   = aws_iam_role.config.id
}

data "aws_iam_policy_document" "config_s3_access" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.config.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
  }
}
