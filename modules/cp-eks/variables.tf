variable "namespace" {
  type = string
}
variable "region" {
  type    = string
  default = "eu-west-1"
}
variable "name" {
  type = string
}
variable "stage" {
  type = string
}
variable "delimiter" {
  type    = string
  default = "-"
}
variable "attributes" {
  type    = list
  default = []
}
variable "tags" {
  type = map
}
variable "kubeconfig_path" {
  type    = string
  default = "/opt"
}
variable "kubernetes_version" {
  type    = string
  default = ""
}
variable "autoscaling_policies_enabled" {
  type    = bool
  default = false
}
variable "cpu_utilization_high_threshold_percent" {
  type    = number
  default = 60
}
variable "cpu_utilization_low_threshold_percent" {
  type    = number
  default = 15
}
variable "availability_zones" {
  type    = list
  default = ["eu-west-1a", "eu-west-1b"]
}
variable "eks_workers_max_size" {
  type    = number
  default = 4
}
variable "eks_workers_min_size" {
  type    = number
  default = 2
}
variable "eks_workers_instance_type" {
  type    = string
  default = "t3a.small"
}
variable "eks_workers_health_check_type" {
  type    = string
  default = "EC2"
}
variable "eks_workers_wait_for_capacity_timeout" {
  type    = string
  default = "10m"
}

