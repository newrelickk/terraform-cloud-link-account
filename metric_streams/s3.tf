resource "aws_s3_bucket" "firehose_event" {
  bucket = "${var.bucket_prefix}-firehose-event"
}

resource "aws_s3_bucket_acl" "firehose_event" {
  bucket = aws_s3_bucket.firehose_event.id
  acl    = "private"
}

resource "aws_s3_bucket" "config" {
  bucket = "${var.bucket_prefix}-metric-stream-config"
}

resource "aws_s3_bucket_acl" "config" {
  bucket = aws_s3_bucket.config.id
  acl    = "private"
}
