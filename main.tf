
resource "lxd_profile" "rke_profile" {

  for_each = {
    for index, profile in var.rke_profiles :
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
      pool = "nb-disk"
      path = "/"
      size = each.value.disk
    }
  }

}

resource "lxd_instance" "rke_container" {
  depends_on = [ 
    lxd_profile.rke_profile
  ]

  for_each = {
    for index, container in var.rke_container :
    container.name => container
  }

  name = each.key
  image = var.rke_image
  type = "virtual-machine"
  profiles = [
    each.value.profile
  ]

  device {
    name = "ens3"
    type = "nic"
    properties = {
      network = "rke-net"
      "ipv4.address" = "${each.value.ip}"
    }
  }

}

resource "lxd_network" "rke-net" {
  name = "rke-net"

  config = {
    "ipv4.address" = "${var.ip_network}"
    "ipv4.nat"     = "true"
    "ipv6.address" = "none"
    "ipv6.nat"     = "false"
  }
}
