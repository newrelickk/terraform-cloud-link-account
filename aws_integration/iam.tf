resource "aws_iam_role" "newrelic_integrations" {
  name               = "NewRelicInfrastructure-Integrations-yohira2"
  assume_role_policy = data.aws_iam_policy_document.newrelic_integrations.json
}

data "aws_iam_policy_document" "newrelic_integrations" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    condition {
      test = "StringEquals"
      // NewRelic AccountID
      values   = [var.newrelic_account_id]
      variable = "sts:ExternalID"
    }

    principals {
      identifiers = [var.another_aws_account_id]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role_policy_attachment" "read_only_access" {
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.newrelic_integrations.id
}

resource "aws_iam_role_policy" "budget_access" {
  name   = "budget-access"
  policy = data.aws_iam_policy_document.budget_access.json
  role   = aws_iam_role.newrelic_integrations.id
}

data "aws_iam_policy_document" "budget_access" {
  statement {
    actions   = ["budgets:ViewBudget"]
    effect    = "Allow"
    resources = ["*"]
  }
  version = "2012-10-17"
}
