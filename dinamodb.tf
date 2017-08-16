resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "${var.table_name}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"


  attribute {
    name = "UserId"
    type = "S"
  }
  }
