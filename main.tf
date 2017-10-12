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
      haproxy_ip = "${var.haproxy_ip}"
      }

}

data "template_file" "logstash" {
  template = "${file("${path.module}/${var.path_to_lstash}")}"

  vars {
    proxy_dns = "${var.haproxy_ip}"
    puppet_ip = "${var.puppet_ip}"
    dns_name = "${var.dns_name}"
  }
}
