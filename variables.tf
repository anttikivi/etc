variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "os_login_public_key" {
  type      = string
  sensitive = true
}
