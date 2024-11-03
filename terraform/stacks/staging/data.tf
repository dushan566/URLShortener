# Data source to get the AWS account ID
data "aws_caller_identity" "current" {}
#--------------------------------------------------------------------------------------------------------

# Lambda Assume Role Policy.
data "aws_iam_policy_document" "lambda_assume_role_policy" {
   statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "edgelambda.amazonaws.com"
      ]
    }
  }
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}
#--------------------------------------------------------------------------------------------------------

# Cloudwatch Logging Policy
data "aws_iam_policy_document" "cloudwatch_logging_policy" {
  statement {
    actions = [
        "logs:CreateLogGroup"
    ]
    resources = ["arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"]
    effect = "Allow"
  }
  statement {
    actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.application_name}:*"]
    effect = "Allow"
  }
}
#--------------------------------------------------------------------------------------------------------

# Secret Manager Policy
data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    actions = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
    ]
    resources = [
      "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:${lower(local.application_name)}/api-keys-*"
      ]
    effect = "Allow"
  }
  statement {
    actions = [
        "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
    effect = "Allow"
  }
}
#--------------------------------------------------------------------------------------------------------

# KMS access Policy
data "aws_iam_policy_document" "kms_access_policy" {
  statement {
    actions = [
        "kms:ListKeys",
        "kms:DescribeKey",
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:ReEncryptFrom",
        "kms:ReEncryptTo",
        "kms:GenerateDataKey"
    ]
    resources = [
      "arn:aws:kms:us-east-1:*:alias/${local.application_name}"
      ]
    effect = "Allow"
  }
}
#--------------------------------------------------------------------------------------------------------

# Dynamodb access Policy
data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    actions = [
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
    ]
    resources = [
        "arn:aws:dynamodb:us-east-1:${data.aws_caller_identity.current.account_id}:table/${local.application_name}Table",
        "arn:aws:dynamodb:us-east-1:${data.aws_caller_identity.current.account_id}:table/${local.application_name}Table/index/longUrl-index"
      ]
    effect = "Allow"
  }
}