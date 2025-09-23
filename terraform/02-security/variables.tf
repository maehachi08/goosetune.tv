# Security Variables
variable "acme_email" {
  description = "Email address for ACME/Let's Encrypt registration"
  type        = string
}

variable "rails_master_key" {
  description = "Rails master key for credentials"
  type        = string
  sensitive   = true
}

variable "mysql_password" {
  description = "Password for the MySQL database"
  type        = string
  sensitive   = true
}