k3s_profiles = [
  {
    name = "k3s_master"
    limits = {
      cpu    = 4
      memory = "4GiB"
      disk   = "50GiB"
    }
  },
  {
    name = "k3s_wok3sr"
    limits = {
      cpu    = 6
      memory = "6GiB"
      disk   = "50GiB"
    }
  }
]

k3s_image = "ubuntu:22.04"

ip_network = "10.10.214.1/24"

k3s_container = [ 
  {
    name    = "k3s-master-01"
    profile = "k3s_master"
    ip      = "10.10.214.10"
  },
    {
    name    = "k3s-master-02"
    profile = "k3s_master"
    ip      = "10.10.214.11"
  },
    {
    name    = "k3s-master-03"
    profile = "k3s_master"
    ip      = "10.10.214.12"
  },
    {
    name    = "k3s-wok3sr-01"
    profile = "k3s_wok3sr"
    ip      = "10.10.214.21"
  },
    {
    name    = "k3s-wok3sr-02"
    profile = "k3s_wok3sr"
    ip      = "10.10.214.22"
  },
]

