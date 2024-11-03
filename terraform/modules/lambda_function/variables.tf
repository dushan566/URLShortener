variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "handler" {
  description = "The function within your code to execute, e.g., main.handler."
  type        = string
  default     = "main.handler"
}

variable "runtime" {
  description = "Lambda function runtime."
  type        = string
  default     = "python3.11"
}

variable "role_arn" {
  description = "The ARN of the IAM role that Lambda assumes when it executes your function."
  type        = string
}

variable "source_path" {
  description = "The path to the folder containing the Lambda code to upload."
  type        = string
  default     = "./code"
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda function can use."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The maximum time in seconds that Lambda allows a function to run before stopping it."
  type        = number
  default     = 4
}

variable "publish" {
  type        = bool
  default     = true
}

variable "tags" {
  type = map(any)
}