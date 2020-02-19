module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=0.8.1"
  namespace  = "bemit"
  stage      = "test"
  name       = "k8s"
  cidr_block = "10.127.0.0/16"
}
