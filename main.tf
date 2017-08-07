data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.3_HVM-20170613-x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/${var.path_to_file}")}"

  vars {
      haproxy_ip = "${aws_instance.haproxy.private_ip}"
      }
}

resource "aws_instance" "haproxy" {
  count                       = 1
  key_name                    = "${var.key_name}"
  ami                         = "${data.aws_ami.centos7.id}"
  instance_type               = "${var.instype}"
  user_data                   = "${data.template_file.userdata.rendered}"
  subnet_id                   = "${element(var.subnet_id, count.index)}"
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
}

data "template_file" "logstash" {
  template = "${file("${path.module}/${var.path_to_lstash}")}"

  vars {
    proxy_dns = "${aws_instance.haproxy.private_dns}"
    puppet_ip = "${puppet_ip}"
    dns_name = "${dns_name}"
  }
}

resource "aws_instance" "logstash" {
  count           = 1
  key_name        = "${var.key_name}"
  ami             = "${data.aws_ami.centos7.id}"
  instance_type   = "${var.instype}"
  user_data       = "${data.template_file.logstash.rendered}"
  subnet_id       = "${element(var.subnet_priv_id, count.index)}"
  security_groups = ["${aws_security_group.logstash.id}"]
  depends_on      = ["aws_security_group.logstash"]

  tags {
    Name = "${count.index}.logstash"
  }
}

resource "aws_security_group" "logstash" {
  name        = "secgrouplogstash"
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
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["10.231.230.0/24"]
  }

  tags {
    Name = "logstash secgroup"
  }
}
