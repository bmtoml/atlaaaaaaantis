module "test-k8s-cluster" {
  source    = "./modules/cp-eks"
  namespace = "bemit"
  stage     = "testing"
  region    = "eu-west-1"
  name      = "johnholm"
  tags      = {}
  providers {
    aws = "aws"
  }

}
