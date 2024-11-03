resource "aws_dynamodb_table" "this" {
  name           = "${var.application_name}Table"
  billing_mode   = "PAY_PER_REQUEST"
  stream_enabled = false
  deletion_protection_enabled  = false
  hash_key       = "shortUrl"

  attribute {
    name = "shortUrl"
    type = "S"
  }

  attribute {
    name = "longUrl"
    type = "S"
  }

  global_secondary_index {
    name               = "longUrl-index"
    hash_key           = "longUrl"
    range_key          = ""
    projection_type    = "ALL"
  }

  tags = merge(var.tags, {Name = "${var.application_name}Table"})
}