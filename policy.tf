
data "aws_iam_policy_document" "cross_role_access" {
   statement {
      actions =[
          "kinesis:*",
      ]

      resources =[
          "arn:aws:kinesis:*:${var.account_id}:stream/${stream_name}",
      ]
  }
}

resource "aws_iam_policy" "cross_acc_access_policy" {
  name        = "terraform_access_to_kinesis_in_other_acc"
  description = "access_to_role"
  policy      = "${data.aws_iam_policy_document.cross_role_access.json}"
}

resource "aws_iam_role" "logstash" {
  name = "logstash_vm"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  depends_on = ["aws_iam_policy.cross_acc_access_policy"]
}

resource "aws_iam_role_policy_attachment" "logstash_attach" {
  role       = "${aws_iam_role.logstash.name}"
  policy_arn = "${aws_iam_policy.cross_acc_access_policy.arn}"
  depends_on = ["aws_iam_role.logstash"]
}

resource "aws_iam_instance_profile" "logstash_profile" {
  name       = "logstash_profile"
  role       = "${aws_iam_role.logstash.name}"
  depends_on = ["aws_iam_role_policy_attachment.logstash_attach"]
}
