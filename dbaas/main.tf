## Network

data "openstack_networking_network_v2" "network_for_dbaas" {
  name = "main_network"
}

data "openstack_networking_subnet_v2" "subnet_for_dbaas" {
  cidr = "10.20.30.0/24"
}

## Datastore
data "selectel_dbaas_datastore_type_v1" "dt" {
  project_id = var.project_id
  region     = var.region
  filter {
    engine  = "postgresql"
    version = "12"
  }
}

# Cluster DBaaS
resource "selectel_dbaas_datastore_v1" "datastore_1" {
  name       = "datastore-1"
  project_id = var.project_id
  region     = var.region
  type_id    = data.selectel_dbaas_datastore_type_v1.dt.datastore_types[0].id
  subnet_id  = data.openstack_networking_subnet_v2.subnet_for_dbaas.id
  node_count = 1
  flavor {
    vcpus = 2
    ram   = 4096
    disk  = 16
  }
  pooler {
    mode = "transaction"
    size = 50
  }
  lifecycle {
    ignore_changes = [
      type_id,
      subnet_id
    ]
  }
}

# DBaaS user
resource "selectel_dbaas_user_v1" "dbaas_user" {
  project_id   = var.project_id
  region       = var.region
  datastore_id = selectel_dbaas_datastore_v1.datastore_1.id
  name         = var.database_user_name
  password     = var.database_user_password
}

# DBaaS database
resource "selectel_dbaas_database_v1" "database_1" {
  project_id   = var.project_id
  region       = var.region
  datastore_id = selectel_dbaas_datastore_v1.datastore_1.id
  owner_id     = selectel_dbaas_user_v1.dbaas_user.id
  name         = var.database_name
  lc_ctype     = "ru_RU.utf8"
  lc_collate   = "ru_RU.utf8"
}

# DBaaS extension
data "selectel_dbaas_available_extension_v1" "ae" {
  project_id = var.project_id
  region     = var.region
  filter {
    name = "hstore"
  }
}

resource "selectel_dbaas_extension_v1" "extension_1" {
  project_id             = var.project_id
  region                 = var.region
  datastore_id           = selectel_dbaas_datastore_v1.datastore_1.id
  database_id            = selectel_dbaas_database_v1.database_1.id
  available_extension_id = data.selectel_dbaas_available_extension_v1.ae.available_extensions[0].id
}
