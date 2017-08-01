output "ppublic_dns" {
  value = "${aws_instance.haproxy.public_dns}"
}

output "public_ip" {
  value = "${aws_instance.haproxy.public_ip}"
}

output "private_dns" {
  value = "${aws_instance.haproxy.private_dns}"
}

output "private_ip" {
  value = "${aws_instance.haproxy.private_ip}"
}
