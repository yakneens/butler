
variable "region" {
	default="CHANGE ME"
}

variable "access_key" {
	default="CHANGE ME"
}

variable "secret_key" {
	default = "CHANGE ME"
}

variable "key_path" {
	default="/home/butler/.ssh/authorized_keys"
}

variable "key_name" {
	default = "sergei"
}

variable "public_key_path" {
	default="~/.ssh/sergei.pub"
}

variable "private_key_path" {
	default="~/.ssh/sergei.pem"
}

variable "username" {
	default="centos"
}

variable "worker_count" {
	default="1"
}

variable "aws_amis" {
  default = {
    eu-central-1 = "ami-1d1ea272"
  }
}

variable "salt-master-flavor" {
	default="t2.xlarge"
}
variable "worker-flavor" {
	default="t2.xlarge"
}

variable "db-server-flavor" {
	default="t2.xlarge"
}

variable "job-queue-flavor" {
	default="t2.xlarge"
}

variable "tracker-flavor" {
	default="t2.xlarge"
}