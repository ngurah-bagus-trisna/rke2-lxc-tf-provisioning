rke_profiles = [
  {
    name = "rke_master"
    limits = {
      cpu    = 4
      memory = "4GiB"
      disk   = "50GiB"
    }
  },
  {
    name = "rke_worker"
    limits = {
      cpu    = 6
      memory = "6GiB"
      disk   = "50GiB"
    }
  }
]

rke_image = "ubuntu:22.04"

rke_container = [ 
  {
    name    = "rke-master-01"
    profile = "rke_master"
    ip      = "10.10.214.10"
  },
    {
    name    = "rke-master-02"
    profile = "rke_master"
    ip      = "10.10.214.11"
  },
    {
    name    = "rke-master-03"
    profile = "rke_master"
    ip      = "10.10.214.12"
  },
    {
    name    = "rke-worker-01"
    profile = "rke_worker"
    ip      = "10.10.214.21"
  },
    {
    name    = "rke-worker-02"
    profile = "rke_worker"
    ip      = "10.10.214.22"
  },
]

