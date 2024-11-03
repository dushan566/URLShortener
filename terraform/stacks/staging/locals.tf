locals {

  application_name = "URLShortener"

  tags = {
   Environment = "Staging"
   Application = "URL Shortener"
   ManagedBy   = "Terrafrom"
   Team        = "SRE"
  }
}