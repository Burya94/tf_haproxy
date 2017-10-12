resource "aws_instance" "logstash" {
  count           = 1
  key_name        = "${var.key_name}"
  ami             = "${data.aws_ami.centos7.id}"
  instance_type   = "${var.instype}"
  iam_instance_profile = "${aws_iam_instance_profile.logstash_profile.name}"
  user_data       = "${data.template_file.logstash.rendered}"
  subnet_id       = "${element(var.subnet_priv_id, count.index)}"
  security_groups = ["${aws_security_group.logstash.id}"]
  depends_on      = ["aws_security_group.logstash", "aws_instance.haproxy"]

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
  ingress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks   = ["10.231.240.0/24"]
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
