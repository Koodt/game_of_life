### Network
## Get external network
data "openstack_networking_network_v2" "external_net" {
  name = "external-network"
}

## Create router with access to external network
resource "openstack_networking_router_v2" "main_router" {
  name                = "main_router"
  external_network_id = data.openstack_networking_network_v2.external_net.id
}

## Create isolate network
resource "openstack_networking_network_v2" "main_network" {
  name = "main_network"
}

## Create subnet for private network
resource "openstack_networking_subnet_v2" "main_subnet" {
  network_id      = openstack_networking_network_v2.main_network.id
  name            = "10.20.30.0/24"
  cidr            = "10.20.30.0/24"
  enable_dhcp     = false
  dns_nameservers = ["188.93.16.19", "188.93.17.19"]
}

## Create subnet for ext network
resource "openstack_networking_subnet_v2" "ext_subnet" {
  network_id      = openstack_networking_network_v2.main_network.id
  name            = "10.50.90.0/24"
  cidr            = "10.50.90.0/24"
  enable_dhcp     = false
  dns_nameservers = ["188.93.16.19", "188.93.17.19"]
}


## Router's port for private net
resource "openstack_networking_port_v2" "main_subnet_main_router_port" {
  name       = "main_subnet_main_router_port"
  network_id = openstack_networking_network_v2.main_network.id

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.main_subnet.id
    ip_address = "10.20.30.1"
  }
}

## Router's port for ext net
resource "openstack_networking_port_v2" "ext_subnet_main_router_port" {
  name       = "ext_subnet_main_router_port"
  network_id = openstack_networking_network_v2.main_network.id

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.ext_subnet.id
    ip_address = "10.50.90.1"
  }
}

## Router's port attachment for private net
resource "openstack_networking_router_interface_v2" "main_router_external_port_for_private" {
  router_id = openstack_networking_router_v2.main_router.id
  port_id   = openstack_networking_port_v2.main_subnet_main_router_port.id
}

## Router's port attachment for ext net
resource "openstack_networking_router_interface_v2" "main_router_external_port_for_ext" {
  router_id = openstack_networking_router_v2.main_router.id
  port_id   = openstack_networking_port_v2.ext_subnet_main_router_port.id
}

## Keypair
resource "selectel_vpc_keypair_v2" "keypair_1" {
  name       = var.keypair_name
  public_key = var.keypair_public_key
  user_id    = var.keypair_user_id

  lifecycle {
    ignore_changes = [
      regions
    ]
  }
}
