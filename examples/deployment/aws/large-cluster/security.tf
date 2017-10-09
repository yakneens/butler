resource "aws_security_group" "butler_external" {
  name = "butler_external"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  vpc_id = "${aws_vpc.butler.id}"
}

resource "aws_security_group" "butler_internal" {
  name = "butler_internal"
  
  vpc_id = "${aws_vpc.butler.id}"
  
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_key_pair" "butler_auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}