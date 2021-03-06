resource "aws_instance" "haproxy" {
  count                       = 1
  key_name                    = "${var.key_name}"
  ami                         = "${data.aws_ami.centos7.id}"
  instance_type               = "${var.instype}"
  user_data                   = "${data.template_file.userdata.rendered}"
  subnet_id                   = "${element(var.subnet_id, count.index)}"
  private_ip                  = "${var.haproxy_ip}"
  associate_public_ip_address = true
  source_dest_check           = false
  security_groups             = ["${aws_security_group.haproxy.id}"]
  depends_on                  = ["aws_security_group.haproxy"]

  tags {
    Name = "${count.index}.HAProxy"
  }
}

resource "aws_security_group" "haproxy" {
  name        = "secgroupHAproxy"
  vpc_id      = "${var.vpc_id}"
  description = "Allow trafic 9200-*"

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "HAProxy secgroup"
  }
  ingress {
      from_port = 9200
      to_port   = 9200
      protocol  = "tcp"
      cidr_blocks = ["10.231.0.0/16"]
  }
}
