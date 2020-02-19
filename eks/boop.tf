resource "aws_vpc" "boop" {
  count      = 1
  cidr_block = "192.127.127.0/24"
}

