terraform {
  required_providers {
    selectel = {
      source = "selectel/selectel"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = ">= 1.49.0"
    }
  }
  required_version = ">= 1.3.9"
}
