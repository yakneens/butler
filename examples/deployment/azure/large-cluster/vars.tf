
variable "subscription_id" {
	default="CHANGE_ME"
}
variable "client_id" {
	default="CHANGE_ME"
}
variable "client_secret" {
	default="CHANGE_ME"
}
variable "tenant_id" {
	default="CHANGE_ME"
}

variable "region" {
	default="West Europe"
}

variable "key_path" {
	default="/home/butler/.ssh/authorized_keys"
}

variable "public_key_path" {
	default="~/.ssh/sergei.pub"
}

variable "private_key_path" {
	default="~/.ssh/sergei.pem"
}

variable "username" {
	default="butler"
}

variable "worker_count" {
	default="1"
}