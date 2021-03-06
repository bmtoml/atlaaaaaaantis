
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = compact(concat(var.attributes, list("cluster")))
  tags       = var.tags
}

locals {
  # The usage of the specific kubernetes.io/cluster/* resource tags below are required
  # for EKS and Kubernetes to discover and manage networking resources
  # https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html#base-vpc-networking
  tags = merge(var.tags, map("kubernetes.io/cluster/${module.label.id}", "shared"))

  # Unfortunately, most_recent (https://github.com/cloudposse/terraform-aws-eks-workers/blob/34a43c25624a6efb3ba5d2770a601d7cb3c0d391/main.tf#L141)
  # variable does not work as expected, if you are not going to use custom AMI you should
  # enforce usage of eks_worker_ami_name_filter variable to set the right kubernetes version for EKS workers,
  # otherwise the first version of Kubernetes supported by AWS (v1.11) for EKS workers will be used, but
  # EKS control plane will use the version specified by kubernetes_version variable.
  eks_worker_ami_name_filter = "amazon-eks-node-${var.kubernetes_version}*"
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  cidr_block = "172.16.0.0/16"
  tags       = local.tags
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.19.0"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = var.attributes
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  tags                 = local.tags
}

module "eks_workers" {
  source                             = "git::https://github.com/cloudposse/terraform-aws-eks-workers.git?ref=tags/0.13.0"
  namespace                          = var.namespace
  stage                              = var.stage
  name                               = var.name
  attributes                         = var.attributes
  tags                               = var.tags
  instance_type                      = var.eks_workers_instance_type
  eks_worker_ami_name_filter         = local.eks_worker_ami_name_filter
  vpc_id                             = module.vpc.vpc_id
  subnet_ids                         = module.subnets.public_subnet_ids
  health_check_type                  = var.eks_workers_health_check_type
  min_size                           = var.eks_workers_min_size
  max_size                           = var.eks_workers_max_size
  wait_for_capacity_timeout          = var.eks_workers_wait_for_capacity_timeout
  cluster_name                       = module.label.id
  cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
  cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data
  cluster_security_group_id          = module.eks_cluster.security_group_id

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = var.autoscaling_policies_enabled
  cpu_utilization_high_threshold_percent = var.cpu_utilization_high_threshold_percent
  cpu_utilization_low_threshold_percent  = var.cpu_utilization_low_threshold_percent
}

module "eks_cluster" {
  source     = "git::https://github.com/cloudposse/terraform-aws-eks-cluster.git?ref=tags/0.20.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  tags       = var.tags
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.public_subnet_ids
  region     = var.region
  #required for atlantis
  install_aws_cli = false
  install_kubectl = false
  external_packages_install_path = "~/.terraform/"
  configmap_auth_file = ".terraform/configmap-auth.yaml"
  #/required for atlantis

  kubernetes_version = var.kubernetes_version
  kubeconfig_path    = "${var.namespace}-${var.stage}-${var.name}.kubeconfig"

  oidc_provider_enabled = false

  workers_security_group_ids = [module.eks_workers.security_group_id]
  workers_role_arns          = [module.eks_workers.workers_role_arn]
}

variable "kubernetes_version" {
  type    = string
  default = ""
}

