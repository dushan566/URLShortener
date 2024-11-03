data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  description             = "KMS key for Secretmanager"
  enable_key_rotation     = true
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
  tags                    = merge(var.tags, {Name = "${var.application_name}-KMS-Key"})
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.application_name}"
  target_key_id = aws_kms_key.this.key_id
}