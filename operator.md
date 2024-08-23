## AWS EventBridge

AWS EventBridge is a serverless event bus service that makes it easier to build event-driven applications. Using EventBridge, you can collect data from your applications and SaaS applications and route that data to your AWS services.

### Design Decisions

- **Separate IAM Policies**: Separate IAM policies are used to grant precise permissions for writing to the EventBridge bus, enhancing security by enforcing the principle of least privilege.
- **Naming Conventions**: Names are dynamically created using metadata variables to ensure consistency and avoid naming conflicts.
- **Assumable Roles**: The AWS provider configuration assumes roles using provided ARN and external IDs to facilitate secure cross-account management.

### Runbook

#### IAM Policy Issues

If you encounter issues related to IAM policies while trying to send events to your EventBridge bus, verify the attached policies:

1. **Check IAM Policies in AWS Console**

    Ensure that the correct IAM policy is attached to the role. Navigate to the IAM console and verify the policies attached to the role responsible for sending events.

2. **AWS CLI Commands**

    Use the AWS CLI to list policies attached to the IAM role:

    ```sh
    aws iam list-attached-role-policies --role-name <role_name>
    ```

    Expect a JSON response listing the policies. Make sure they include the necessary permissions similar to:

    ```json
    {
        "AttachedPolicies": [
            {
                "PolicyName": "<policy_name>",
                "PolicyArn": "arn:aws:iam::<account_id>:policy/<policy_name>"
            }
        ]
    }
    ```

#### Event Delivery Failures

If events are failing to deliver to your EventBridge:

1. **CloudWatch Logs**

    Check CloudWatch Logs for any errors. Navigate to the CloudWatch console, find the log group associated with EventBridge, and inspect the logs for error messages.

2. **EventBridge Rule**

    Validate that the EventBridge rule is correctly configured:

    ```sh
    aws events describe-rule --name <rule_name>
    ```

    Ensure that the rule is enabled and properly targets the desired AWS services.

#### Event Target Issues

If event targets are not behaving as expected:

1. **List Rule Targets**

    Check which targets are associated with the EventBridge rule:

    ```sh
    aws events list-targets-by-rule --rule <rule_name>
    ```

    Verify the output and ensure the correct targets are listed.

    ```json
    {
        "Targets": [
            {
                "Id": "<target_id>",
                "Arn": "arn:aws:<target_service>:<account_id>:<resource_id>"
            },
            // Additional targets
        ]
    }
    ```

2. **Test Event**

    Test an event to make sure it's processing as expected:

    ```sh
    aws events put-events --entries file://test_event.json
    ```

    Where `test_event.json` contains a JSON object representing a test event.

