resource "aws_secretsmanager_secret" "this" {
  name                    = lower("${var.application_name}/api-keys")
  description             = "${var.application_name} API Keys"
  recovery_window_in_days = var.recovery_window_in_days
  kms_key_id              = aws_kms_key.this.id
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_value
}