## AWS EventBridge

AWS EventBridge is a serverless event bus service that makes it easy to connect applications using data from your own applications, integrated Software-as-a-Service (SaaS) applications, and AWS services. You can create rules that match the incoming events and route them to target services for processing.

### Design Decisions

1. **Event Bus Creation**: The module creates a new AWS CloudWatch Event Bus. The name of the event bus is derived from a prefix provided in the input variables.
2. **IAM Policy for PutEvents**: An IAM policy is created to allow the `PutEvents` action specific to the newly created event bus. This policy can be used to grant necessary permissions to resources that will put events into the bus.
3. **Region Configuration**: The AWS region where the resources are going to be created is taken from the input variables.
4. **Massdriver Integration**: The module uses the `massdriver_artifact` resource to integrate with Massdriver for artifact management and metadata storage. Data such as ARN and IAM policy are exported for external use.

### Runbook

#### Unable to Send Events to EventBridge

If events are not appearing in your EventBridge, it might be an IAM policy issue.

Check the IAM policies:

```sh
aws iam list-policies --query 'Policies[?PolicyName==`your-policy-name`]'
```

Look for the policy associated with PutEvents action and ensure it has the correct permissions.

#### Events Not Appearing in the Log

If your events are not showing up, you might want to review the EventBridge bus.

List the event buses:

```sh
aws events list-event-buses
```

Ensure your event bus exists and has the correct name.

#### Rule Not Triggering

If a rule is not triggering, verify event rules and targets.

List all rules:

```sh
aws events list-rules --event-bus-name your-event-bus-name
```

Ensure the rule you expect is present and active.

Check rule targets:

```sh
aws events list-targets-by-rule --rule your-rule-name
```

Verify that the targets are correctly defined for the rule.

#### IAM Role Issues

Sometimes the IAM role used by your rule might not have sufficient permissions.

Check IAM role:

```sh
aws iam get-role --role-name your-role-name
```

Inspect the attached policies and ensure they grant the necessary permissions.

#### CloudWatch Logs

For additional debugging, enable CloudWatch logging for your EventBridge.

```sh
aws events put-rule --name your-rule-name --event-bus-name your-event-bus-name --state ENABLED --description "description"
aws logs create-log-group --log-group-name your-log-group
aws logs describe-log-groups
```

Ensure that the logs are being created and review them for errors or warnings.

#### Event Structure Issues

Ensure that the events being sent to EventBridge conform to the expected structure.

Example event:

```json
{
  "Source": "your.source",
  "DetailType": "your.detail-type",
  "Detail": "{\"key1\": \"value1\", \"key2\": \"value2\"}",
  "EventBusName": "your-event-bus-name"
}
```

Validate JSON:

```sh
echo '{"key1": "value1", "key2": "value2"}' | python -m json.tool
```

Ensure the JSON structure is valid and properly formatted.

