resource "lxd_network" "k3s-net-1" {
  name = "k3s-net"
  target = "nb-think-ubuntu"
}

resource "lxd_network" "k3s-net-2" {
  name = "k3s-net"
  target = "nb-ubuntu-desk"
}

resource "lxd_network" "k3s-net" {
  depends_on = [
    "lxd_network.k3s-net-1",
    "lxd_network.k3s-net-2",
  ]
  name = "k3s-net"
  type = "bridge"
  config = {
    "ipv4.address" = var.ip_network
    "ipv4.nat"     = "true"
    "ipv6.address" = "none"
    "ipv6.nat"     = "false"
  }
  provisioner "local-exec" {
    command = "sudo firewall-cmd --add-interface=k3s-net --zone=libvirt-routed --permanent && sudo firewall-cmd --reload"
  }
}

resource "lxd_profile" "k3s_profile" {
  depends_on = [ lxd_network.k3s-net ]
  for_each = {
    for profile in var.k3s_profiles :
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

resource "lxd_instance" "k3s_container" {
  depends_on = [ lxd_profile.k3s_profile, lxd_network.k3s-net ]

  for_each = {
    for container in var.k3s_container :
    container.name => container
  }

  name = each.key
  image = var.k3s_image
  type = "virtual-machine"
  profiles = [ each.value.profile ]
  target = "nb-ubuntu-desk"
  config = {
    cloud-init.ssh-keys.mykey = "ubuntu:gh:ngurah-bagus-trisna"
  }

  device {
    name = "ens3"
    type = "nic"
    properties = {
      network = "k3s-net"
      "ipv4.address" = each.value.ip
    }
  }
}
