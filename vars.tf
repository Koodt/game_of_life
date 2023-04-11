variable "os_auth_url" {
  default = "https://api.selvpc.ru/identity/v3"
}

variable "region" {
  default = "ru-9"
}

variable "availability_zone" {
  default = "ru-9a"
}


variable "database_name" {
  default = "game_of_life"
}

variable "project_id" {
  sensitive = true
}

variable "user_name" {
  sensitive = true
}

variable "user_password" {
  sensitive = true
}

variable "sel_account" {
  sensitive = true
}

variable "sel_token" {
  sensitive = true
}

variable "database_user_name" {
  sensitive = true
}

variable "database_user_password" {
  sensitive = true
}

variable "keypair_user_id" {
  sensitive = true
}

variable "keypair_name" {
  sensitive = true
}
