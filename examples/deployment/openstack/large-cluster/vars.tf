
variable "user_name" {
	default="CHANGE_ME"
}
variable "password" {
	default="CHANGE_ME"
}
variable "tenant_name" {
	default=""
}
variable "auth_url" {
	
}

variable "key_pair" {
	default=""
}


variable "bastion_key_file" {

}

variable "bastion_host" {

}

variable "bastion_user" {
	default = ""
}

variable "image_id" {
	default = ""
}

variable "user" {
	default = "centos"
}

variable "key_file" {

}

variable "network_name" {
	default = ""
}

variable "main_network_id" {
	default=""
}

}

variable "floatingip_pool" {
	default = ""
}

variable "worker_count" {
	default="1"
}

variable "salt-master-flavor" {
	default="s1.massive"
}

variable "worker-flavor" {
	default="s1.massive"
}

variable "db-server-flavor" {
	default="s1.massive"
}

variable "job-queue-flavor" {
	default="s1.massive"
}

variable "tracker-flavor" {
	default="s1.massive"
}

variable "main-security-group-id" {
	default=""
}