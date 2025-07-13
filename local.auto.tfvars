k3s_profiles = [
  {
    name = "k3s_master"
    limits = {
      cpu    = 2
      memory = "4GiB"
      disk   = "50GiB"
    }
  },
  {
    name = "k3s_worker"
    limits = {
      cpu    = 4
      memory = "4GiB"
      disk   = "50GiB"
    }
  }
]

k3s_image = "ubuntu:24.04"

ip_network = "240.0.0.0/8"

k3s_container = [ 
  {
    name    = "k3s-master-01"
    profile = "k3s_master"
    ip      = "240.10.0.10"
  },
    {
    name    = "k3s-master-02"
    profile = "k3s_master"
    ip      = "240.10.0.11"
  },
    {
    name    = "k3s-master-03"
    profile = "k3s_master"
    ip      = "240.10.0.12"
  },
    {
    name    = "k3s-worker-01"
    profile = "k3s_worker"
    ip      = "240.10.0.21"
  },
    {
    name    = "k3s-worker-02"
    profile = "k3s_worker"
    ip      = "240.10.0.22"
  },
]

pool = "prod-brtfs"
