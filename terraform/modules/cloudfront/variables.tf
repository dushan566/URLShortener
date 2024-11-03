variable "domains" {
  description = "Additional CNAMEs (alternative domain names) for this CloudFront distribution."
  type        = list(string)
  default     = []
}

variable "application_name" {
  description = "Your application name."
  type        = string
}

variable "origin_domain" {
  description = "The domain name of the origin server for this CloudFront distribution."
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "The Amazon Resource Name (ARN) of the ACM SSL/TLS certificate to associate with this distribution."
  type        = string
}

variable "lambda_at_edge" {
  description = "Boolean flag to specify whether a Lambda@Edge function should be attached to this distribution."
  type        = bool
  default     = false
}

variable "lambda_arn" {
  description = "The Amazon Resource Name (ARN) of the Lambda@Edge function to be associated with this CloudFront distribution."
  type        = string
  default     = ""
}

variable "tags" {
    type = map(any)
    default = {}
}