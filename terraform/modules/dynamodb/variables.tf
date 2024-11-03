variable "application_name" {
  description = "Your application name."
  type        = string
}

variable "tags" {
  description = "List of tags"
  type        = map(any)
}