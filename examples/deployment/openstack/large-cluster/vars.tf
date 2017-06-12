
variable "user_name" {
	default="CHANGE_ME"
}
variable "password" {
	default="CHANGE_ME"
}
variable "tenant_name" {
	default="Pan-Prostate"
}
variable "auth_url" {
	
}

variable "key_pair" {
	default="sergei"
}


variable "bastion_key_file" {

}

variable "bastion_host" {

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