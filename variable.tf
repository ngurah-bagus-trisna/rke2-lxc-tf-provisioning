variable "rke_profiles" {
  type = list(object({
    name = string
    limits = object({
      cpu = number
      memory = string
      disk = string
    }) 
  }))
}

variable "rke_image" {
  type = string
  default = "ubuntu:22.04"
  
}

variable "rke_container" {
  type = list(object({
    name    = string
    profile = string
    ip      = string 
  }))
}
