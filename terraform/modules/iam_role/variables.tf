variable "name" {}

variable "custom_policies" {
  type = set(string)
  default = []
  description = "List of custom policies"
}

variable "assume_role_policy" {
  type = string
  description = "Assume Role Policy"
}

variable "aws_managed_policy_arns" {
  type = set(string)
  default = []
  description = "List of AWS managed roles"
}


variable "tags" {
  type = map(string)
  description = "all tags"
}


