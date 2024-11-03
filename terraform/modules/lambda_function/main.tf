# Archive the source folder into a zip file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_code_path
  output_path = "${var.source_code_path}/lambda_function.zip"
}

# Lambda function
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout
  publish       = var.publish

  # The archived file created from source_path
  filename         = data.archive_file.lambda_zip.output_path
  # Update lambda version when the code is changed
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = var.tags

  depends_on = [
    data.archive_file.lambda_zip
  ]
}