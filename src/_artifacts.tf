resource "massdriver_artifact" "infrastructure" {
  field                = "eventbridge"
  provider_resource_id = aws_cloudwatch_event_bus.main.arn
  name                 = "EventBridge ${var.md_metadata.name_prefix}"
  artifact = jsonencode(
    {
      data = {
        infrastructure = {
          arn = aws_cloudwatch_event_bus.main.arn
        }
      }
      specs = {
        aws = {
          region   = var.region
        }
      }
    }
  )
}
