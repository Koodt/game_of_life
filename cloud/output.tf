output "network_id" {
  value = openstack_networking_network_v2.main_network.id
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.main_subnet.id
}

output "floating_ip" {
  value = openstack_networking_floatingip_v2.control_node_floating.address
}
