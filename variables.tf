variable "key_name" {}

variable "instype" {
  default = "t2.micro"
}

variable "path_to_file" {
  default = "./haproxy.sh"
}

variable "path_to_lstash" {
  default = "./logstash.sh"
}

variable "subnet_id" {
  type = "list"
}

variable "vpc_id" {}

variable "subnet_priv_id" {
  type = "list"
}
variable "puppet_ip" {}
variable "dns_name" {}
variable "haproxy_ip"{
    default = "10.231.230.10"
}
variable "stream_name" {}
variable "account_id" {}
variable "table_name"{}
