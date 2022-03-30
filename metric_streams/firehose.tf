resource "aws_kinesis_firehose_delivery_stream" "newrelic_delivery_stream" {
  destination = "http_endpoint"
  name        = "newrelic-delivery-stream"

  http_endpoint_configuration {
    name = "New Relic"
    url  = "https://aws-api.newrelic.com/cloudwatch-metrics/v1"
    request_configuration {
      content_encoding = "GZIP"
    }
    access_key         = var.newrelic_license_key
    buffering_interval = 60
    buffering_size     = 1
    retry_duration     = 60
    role_arn           = aws_iam_role.firehose.arn
  }

  s3_configuration {
    compression_format = "GZIP"
    bucket_arn         = aws_s3_bucket.firehose_event.arn
    role_arn           = aws_iam_role.firehose.arn
  }
}

resource "aws_iam_role" "metric_stream" {
  name               = "metric-stream-newrelic"
  description        = "Role to allow a metric stream put metrics into a firehose"
  assume_role_policy = data.aws_iam_policy_document.metric_stream_assume_role.json
  path               = "/service-role/"
}

data "aws_iam_policy_document" "metric_stream_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "sts:ExternalId"
    }
    principals {
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
      type        = "Service"
    }
  }
  version = "2012-10-17"
}

resource "aws_iam_role_policy" "metric_stream_put_records" {
  name   = "metric-streams-firehose-put-records-${var.bucket_prefix}"
  policy = data.aws_iam_policy_document.metric_stream_put_records.json
  role   = aws_iam_role.metric_stream.id
}

data "aws_iam_policy_document" "metric_stream_put_records" {
  statement {
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    effect    = "Allow"
    resources = [aws_kinesis_firehose_delivery_stream.newrelic_delivery_stream.arn]
  }
}

resource "aws_iam_role" "firehose" {
  name               = "firehose-role-newrelic"
  description        = "Role to allow firehose stream put events into S3 backup bucket"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["firehose.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "firehose_s3_access" {
  name   = "firehose-s3-access"
  policy = data.aws_iam_policy_document.firehose_s3_access.json
  role   = aws_iam_role.firehose.id
}

data "aws_iam_policy_document" "firehose_s3_access" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.firehose_event.arn,
      "${aws_s3_bucket.firehose_event.arn}/*"
    ]
  }
  version = "2012-10-17"
}
