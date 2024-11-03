locals {

  application_name = "URLShortener"

  tags = {
   Environment = "Dev"
   Application = "URL Shortener"
   ManagedBy   = "Terrafrom"
   Team        = "SRE"
  }
}