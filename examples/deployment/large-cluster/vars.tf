
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
	default = "70ae9621-7840-488f-bff0-387e7f32d46d"
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

variable "floatingip_pool" {
	default = "ext-net"
}