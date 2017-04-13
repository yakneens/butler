variable "key_pair" {
}

variable "image_id" {
	default = "c96c7d7f-3ade-4bc9-a02c-b8f02a1d5b4c"
}

variable "user" {
	default = "centos"
}

variable "key_file" {

}

variable "network_name" {
	default = "test_network"
}

variable "floatingip_pool" {
	default = "ext-net"
}
