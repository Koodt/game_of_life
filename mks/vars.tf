variable "project_id" {}

variable "region" {}

variable "availability_zone" {}

variable "network_id" {}

variable "subnet_id" {}

variable "kube_version" {}

variable "keypair_name" {}

variable "cluster_name" {
  default = "gameoflife"
}

variable "enable_autorepair" {
  default = true
}

variable "enable_patch_version_auto_upgrade" {
  default = true
}

variable "maintenance_window_start" {
  default = ""
}

variable "affinity_policy" {
  default = ""
}

variable "nodes_count" {
  default = 1
}

variable "cpus" {
  default = 1
}

variable "ram_mb" {
  default = 1024
}

variable "volume_gb" {
  default = 10
}

variable "volume_type" {
  default = "fast.ru-9a"
}

variable "labels" {
  default = {
    "label1":"value1",
    "label2":"value2"
  }
}
