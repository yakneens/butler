
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

variable "key_data" {
	default="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5Wmj5zKTk09u+tLO7/7iRs2VhclKaHFdRfxbqC2nm+htceU+AHa0ePLgmhuXv3aZscBwsSjFf/H0KGPccB6VROhL7wZmQJe5dWfOJvWSZGK5WkLcpO7PGE16hOuU88WCkwRWO/g02uBweYqTzQXCsS29T7qxm5SK9Xgx9YwuG2+u0gZG8cF+gQtjoxOA7uVREstYl27XrHXOS1s8QZ1cRs8MEHwV7ORJpZdXcz8we9d0nQAYUBJWCNhK34quU3jZDtebc1F27zyM3K0YlNxURJLCLpf7KdpyaSzBDYaugEnNdNPB3/wwdU6d8p+Oweuzsw2ESvnGVr7J4iKQlN45b siakhnin@olm-siakhnin.local"
		
}

variable "bastion_key_file" {
	default="CHANGE_ME"
}

variable "bastion_host" {
	default="CHANGE_ME"
}

variable "bastion_user" {
	default = "iakhnin"
}

variable "image_id" {
	default = "7457dc57-9765-4293-ab1b-8e03d748485f"
}

variable "user" {
	default = "centos"
}

variable "key_file" {
	default="CHANGE_ME"
}

variable "network_name" {
	default = "Pan-Prostate_private"
}

variable "main_network_id" {
	default="d506eaf8-88b5-43c3-a751-a198672017e6"
}

variable "pan_prostate_network_id" {
	default="eb60b9be-0d31-41f0-b5d3-f6546cb13a67"
}
variable "gnos_network_id" {
	default="ee244fc2-9540-4523-a642-53d1fad0fb53"
}

variable "floatingip_pool" {
	default = "ext-net"
}