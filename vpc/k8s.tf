module "vpc" {
  count = 0
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = "bemit"
  stage      = "test"
  name       = "k8s"
  cidr_block = "10.127.0.0/16"
}
