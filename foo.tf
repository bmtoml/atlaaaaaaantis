resource "aws_vpc" "boop" {
  count = 0
  cidr_block = "192.127.127.0/24"
}

resource "aws_vpc" "boop2" {
  count = 0
  cidr_block = "192.127.128.0/24"
}

resource "aws_vpc" "boop3" {
  count = 0
  cidr_block = "192.127.129.0/24"
}

resource "aws_vpc" "johnholm" {
  count = 1
  cidr_block = "192.127.129.0/24"
}
