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

## Control node's private port
resource "openstack_networking_port_v2" "main_subnet_control_node_port" {
  name       = "main_subnet_main_router_port"
  network_id = openstack_networking_network_v2.main_network.id

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.main_subnet.id
    ip_address = "10.20.30.10"
  }
}

## Control node's ext port
resource "openstack_networking_port_v2" "ext_subnet_control_node_port" {
  name       = "ext_subnet_main_router_port"
  network_id = openstack_networking_network_v2.main_network.id

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.ext_subnet.id
    ip_address = "10.50.90.10"
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

### Control node
## Get flavor
resource "openstack_networking_floatingip_v2" "control_node_floating" {
  pool = "external-network"
}
data "openstack_compute_flavor_v2" "control_node_flavor" {
  vcpus= 2
  ram = 4096
  disk = 32
  is_public = true
  name = "SL1.2-4096-32"
}

## Control node host
resource "openstack_compute_instance_v2" "control_node" {
  name              = "control_node"
  flavor_id         = data.openstack_compute_flavor_v2.control_node_flavor.id
  key_pair          = var.keypair_name
  image_id          = "a456436d-3321-4c35-b96c-86a873a6ced3"
  availability_zone = var.availability_zone

  network {
    port = openstack_networking_port_v2.main_subnet_control_node_port.id
  }

    network {
    port = openstack_networking_port_v2.ext_subnet_control_node_port.id
  }

  # user_data          = "#!/bin/bash\n\n# Install packages\nDEBIAN_FRONTEND=noninteractive apt update && apt install -y nginx bind9"

  provisioner "remote-exec" {
    inline = [<<EOF
apt update

apt dist-upgrade -y

apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
chmod a+r /etc/apt/keyrings/docker.gpg

curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | bash

apt update

apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  tmux \
  vim \
  gitlab-runner \
  jq \
  python3-pip \
  libpq-dev \
  python3-dev

pip3 install \
  setuptools \
  wheel \
  psycopg2 \
  flake8 \
  black \
  isort


curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

docker run \
    --restart=always \
    --detach \
    --name grafana \
    --publish 10.20.30.10:3000:3000 \
    --volume grafana-storage:/var/lib/grafana \
    grafana/grafana

docker run \
    --detach \
    --name gitlab \
    --restart always \
    --hostname 10.20.30.10 \
    --publish 10.20.30.10:8937:8937 \
    --publish 10.20.30.10:443:443 \
    --publish 10.20.30.10:80:80 \
    --publish 10.20.30.10:8991:8991 \
    --volume gitlab-storage:/etc/gitlab \
    --volume gitlab-logs:/var/log/gitlab \
    --volume gitlab-opt:/var/opt/gitlab \
    --shm-size 256m \
    gitlab/gitlab-ce:latest

mkdir /root/.kube/
mkdir /home/gitlab-runner/.kube/

wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz
tar xf kubeval-linux-amd64.tar.gz
chmod +x ./kubeval
cp kubeval /usr/local/bin

EOF
    ]

    connection {
      type = "ssh"
      user = "root"
      host = openstack_networking_floatingip_v2.control_node_floating.address
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "file" {
    source      = "files/kube/config"
    destination = "/root/.kube/config"

    connection {
      type = "ssh"
      user = "root"
      host = openstack_networking_floatingip_v2.control_node_floating.address
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "file" {
    source      = "files/kube/config"
    destination = "/home/gitlab-runner/.kube/config"

    connection {
      type = "ssh"
      user = "root"
      host = openstack_networking_floatingip_v2.control_node_floating.address
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  depends_on = [
    openstack_networking_floatingip_v2.control_node_floating
  ]

}

## Attach floating to control_node
resource "openstack_networking_floatingip_associate_v2" "association_1" {
  port_id     = openstack_networking_port_v2.ext_subnet_control_node_port.id
  floating_ip = openstack_networking_floatingip_v2.control_node_floating.address
}
