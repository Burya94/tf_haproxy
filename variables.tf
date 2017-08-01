variable "key_name" {}

variable "instype" {
  default = "t2.micro"
}

variable "path_to_file" {
  default = "./haproxy.sh"
}

variable "subnet_id" {
  type = "list"
}

variable "vpc_id" {}
