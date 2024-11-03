
variable "application_name" {
  description = "Your application name."
  type        = string
}

variable "recovery_window_in_days" {
  type = string
  default = "7"
}

variable "secret_value" {
  description = "The value of the secret (as a string)."
  type        = string
}

variable "tags" {
  type = map(any)
}