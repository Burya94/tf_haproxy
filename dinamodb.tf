resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "${var.table_name}"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "leaseKey"


  attribute {
    name = "leaseKey"
    type = "S"
  }
  }
