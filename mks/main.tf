## MKS cluster
resource "selectel_mks_cluster_v1" "cluster_1" {
  name                              = var.cluster_name
  project_id                        = var.project_id
  region                            = var.region
  kube_version                      = var.kube_version
  enable_autorepair                 = var.enable_autorepair
  enable_patch_version_auto_upgrade = var.enable_patch_version_auto_upgrade
  network_id                        = var.network_id
  subnet_id                         = var.subnet_id
}

## MKS nodegroup
resource "selectel_mks_nodegroup_v1" "nodegroup_1" {
  cluster_id        = selectel_mks_cluster_v1.cluster_1.id
  project_id        = var.project_id
  region            = var.region
  availability_zone = var.availability_zone
  nodes_count       = var.nodes_count
  affinity_policy   = var.affinity_policy
  cpus              = var.cpus
  ram_mb            = var.ram_mb
  volume_gb         = var.volume_gb
  volume_type       = var.volume_type
  labels            = var.labels
}

## Kubeconfig
data "selectel_mks_kubeconfig_v1" "kubeconfig" {
  cluster_id  = selectel_mks_cluster_v1.cluster_1.id
  project_id  = var.project_id
  region      = var.region
}
