locals {
  write = [{
    Action   = ["events:PutEvents"]
    Effect   = "Allow"
    Resource = aws_cloudwatch_event_bus.main.arn
  }]
}

resource "aws_iam_policy" "write" {
  name        = "${var.md_metadata.name_prefix}-write-role"
  description = "AWS Eventbridge write policy: ${var.md_metadata.name_prefix}"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.write
  })
}
