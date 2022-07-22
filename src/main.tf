resource "aws_cloudwatch_event_bus" "main" {
  name = var.md_metadata.name_prefix
}
