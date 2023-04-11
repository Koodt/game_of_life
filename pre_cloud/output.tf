output "network_id" {
  value = openstack_networking_network_v2.main_network.id
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.main_subnet.id
}

output "ext_subnet_id" {
  value = openstack_networking_subnet_v2.ext_subnet.id
}
