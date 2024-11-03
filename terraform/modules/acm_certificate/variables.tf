variable "domain_name" {
  type = string
  description = "Short URL Domain name"
}

variable "route53_zone_id" {
  type = string
  default = ""
  description = "Your Route53 Zone ID"
}

variable "tags" {
 type = map(any)
}