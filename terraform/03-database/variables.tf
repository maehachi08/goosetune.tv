# Database Variables
variable "mysql_username" {
  description = "Username for the MySQL database"
  type        = string
  default     = "goosetunetv"
}

variable "mysql_password" {
  description = "Password for the MySQL database"
  type        = string
  sensitive   = true
}