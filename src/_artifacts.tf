resource "massdriver_artifact" "infrastructure" {
  field                = "eventbridge"
  provider_resource_id = aws_cloudwatch_event_bus.main.arn
  name                 = "EventBridge ARN"
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
          resource = "event bus"
          service  = "EventBridge"
        }
      }
    }
  )
}
