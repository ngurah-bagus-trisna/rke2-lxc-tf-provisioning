resource "lxd_network" "rke-net-1" {
  name = "rke-net"
  target = "nb-think-ubuntu"
}

resource "lxd_network" "rke-net-2" {
  name = "rke-net"
  target = "nb-ubuntu-desk"
}

resource "lxd_network" "rke-net" {
  depends_on = [
    "lxd_network.rke-net-1",
    "lxd_network.rke-net-2",
  ]
  name = "rke-net"
  type = "bridge"
  config = {
    "ipv4.address" = var.ip_network
    "ipv4.nat"     = "true"
    "ipv6.address" = "none"
    "ipv6.nat"     = "false"
  }
  provisioner "local-exec" {
    command = "sudo firewall-cmd --add-interface=rke-net --zone=libvirt-routed --permanent && sudo firewall-cmd --reload"
  }
}

resource "lxd_profile" "rke_profile" {
  depends_on = [ lxd_network.rke-net ]
  for_each = {
    for profile in var.rke_profiles :
    profile.name => profile.limits
  }

  name = each.key

  config = {
    "boot.autostart" = false
    "limits.cpu"    = each.value.cpu
    "limits.memory" = each.value.memory
  }

  device {
    type = "disk"
    name = "root"
    properties = {
      pool = "nb-pool-zfs"
      path = "/"
      size = each.value.disk
    }
  }
}

resource "lxd_instance" "rke_container" {
  depends_on = [ lxd_profile.rke_profile, lxd_network.rke-net ]

  for_each = {
    for container in var.rke_container :
    container.name => container
  }

  name = each.key
  image = var.rke_image
  type = "virtual-machine"
  profiles = [ each.value.profile ]
  target = "nb-ubuntu-desk"

  device {
    name = "ens3"
    type = "nic"
    properties = {
      network = "rke-net"
      "ipv4.address" = each.value.ip
    }
  }
}
