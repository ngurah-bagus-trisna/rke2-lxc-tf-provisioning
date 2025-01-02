terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
      version = "2.2.0"
    }
  }
}

provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}
