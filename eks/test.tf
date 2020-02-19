module "test-k8s-cluster" {
  source    = "../modules/cp-eks"
  namespace = "test"
  region    = "eu-west-1"
  name      = "test-k8s-cluster"
  tags      = {}
}
