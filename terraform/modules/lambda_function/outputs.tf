output "lambda_arn" {
  description = "The ARN of the created Lambda function."
  value       = aws_lambda_function.this.arn
}

output "lambda_invoke_arn" {
  description = "The ARN to invoke the Lambda function."
  value       = aws_lambda_function.this.invoke_arn
}

output "version" {
  value = aws_lambda_function.this.version
}

variable "source_code_path" {
 type = string
}