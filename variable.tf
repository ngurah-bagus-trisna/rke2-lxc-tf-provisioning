variable "k3s_profiles" {
  type = list(object({
    name = string
    limits = object({
      cpu = number
      memory = string
      disk = string
    }) 
  }))
}

variable "k3s_image" {
  type = string
  default = "ubuntu:24.04"
  
}

variable "k3s_container" {
  type = list(object({
    name    = string
    profile = string
    ip      = string 
  }))
}

variable "ip_network" {
  type = string
  default = "" 
}
