# IAM Role.
resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = var.assume_role_policy
  tags               = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Attach provided managed policies to the role.
resource "aws_iam_role_policy_attachment" "managed_policy_attachments" {
  for_each   = var.aws_managed_policy_arns
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# Create custom inline policies.
resource "aws_iam_role_policy" "custom_iam_policy" {
  for_each  = toset(var.custom_policies)
  name      = lower("${var.name}-${md5(each.value)}")
  policy    = each.value
  role      = aws_iam_role.this.id
}
