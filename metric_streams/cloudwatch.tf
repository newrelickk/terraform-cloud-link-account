resource "aws_cloudwatch_metric_stream" "metric_stream" {
  name          = "newrelic-metric-stream"
  firehose_arn  = aws_kinesis_firehose_delivery_stream.newrelic_delivery_stream.arn
  output_format = "opentelemetry0.7"
  role_arn      = aws_iam_role.metric_stream.arn
}
