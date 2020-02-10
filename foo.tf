resource "aws_vpc" "boop" {
  count      = 1
  cidr_block = "192.127.127.0/24"
}

resource "aws_vpc" "boop2" {
  count      = 1
  cidr_block = "192.127.128.0/24"
}

