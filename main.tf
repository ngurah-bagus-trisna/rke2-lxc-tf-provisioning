resource "lxd_profile" "k3s_profile" {
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
      pool = var.pool
      path = "/"
      size = each.value.disk
    }
  }
}

resource "lxd_instance" "k3s_container" {
  depends_on = [ lxd_profile.k3s_profile ]

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
    "user.user-data" = <<EOF
#cloud-config
ssh_authorized_keys:
  - ${var.ssh_public_key}
hostname: ${each.key}
EOF
  }

  device {
    name = "ens3"
    type = "nic"
    properties = {
      network = "fanbr"
      "ipv4.address" = each.value.ip
    }
  }
}
