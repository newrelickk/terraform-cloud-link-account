resource "newrelic_cloud_aws_link_account" "example" {
  account_id             = "<Set Your New Relic One Account ID>"
  arn                    = aws_iam_role.newrelic_integrations.arn
  metric_collection_mode = "PULL (API polling) or PUSH (Metric Streams)"
  name                   = "<Set Name>"

  depends_on = [
    aws_iam_role.newrelic_integrations,
    data.aws_iam_policy_document.budget_access,
    data.aws_iam_policy_document.newrelic_integrations,
    aws_iam_role_policy_attachment.read_only_access
  ]
}
