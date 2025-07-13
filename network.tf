#resource "lxd_network" "k3s-net-1" {
#  name = "k3s-net"
#  target = "nb-think-ubuntu"
#}

#resource "lxd_network" "k3s-net-2" {
#  name = "k3s-net"
#  target = "nb-ubuntu-desk"
#}

#resource "lxd_network" "k3s-net" {
#  depends_on = [
#    "lxd_network.k3s-net-1",
#    "lxd_network.k3s-net-2",
#  ]
#  name = "k3s-net"
#  type = "bridge"
#  config = {
#    "ipv4.address" = var.ip_network
#    "ipv4.nat"     = "true"
#    "ipv6.address" = "none"
#    "ipv6.nat"     = "false"
#  }
#  provisioner "local-exec" {
#    command = "sudo firewall-cmd --add-interface=k3s-net --zone=libvirt-routed --permanent && sudo firewall-cmd --reload"
#  }
#}