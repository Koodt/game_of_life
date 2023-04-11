provider "openstack" {
  user_name           = var.user_name
  password            = var.user_password
  tenant_id           = var.project_id
  project_domain_name = var.sel_account
  user_domain_name    = var.sel_account
  auth_url            = var.os_auth_url
  region              = var.region
}

provider "selectel" {
  token = var.sel_token
}

module "Cloud" {
  source = "./cloud"

  keypair_user_id = var.keypair_user_id
  keypair_name = var.keypair_name
  keypair_public_key = file("~/.ssh/id_rsa.pub")
  availability_zone = var.availability_zone
}

module "DBaaS" {
  source = "./dbaas"

  project_id = var.project_id
  region = var.region
  database_user_name = var.database_user_name
  database_user_password = var.database_user_password
  database_name = var.database_name

  depends_on = [
    module.Cloud
  ]
}

module "MKS" {
  source = "./mks"

  project_id = var.project_id
  region = var.region
  availability_zone = var.availability_zone
  kube_version = "1.25.6"
  network_id = module.Cloud.network_id
  subnet_id = module.Cloud.subnet_id
  keypair_name = var.keypair_name

  depends_on = [
    module.Cloud,
    module.DBaaS
  ]
}
