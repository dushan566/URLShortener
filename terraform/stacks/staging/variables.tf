variable "route53_zone_id" {
  type = string
  default = ""
  description = "Pass your Route53 Zone ID from secrets folder"
}

variable "api-user" {
 type = string
 description = "Pass your api user from TF autovars from secrets folder"
}

variable "api-key" {
 type = string
 description = "Pass your api key from TF autovars from secrets folder" 
}