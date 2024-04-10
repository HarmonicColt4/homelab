terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.51.0"
    }
  }

  required_version = ">=1.7.5"
}

locals {
  pve_local_username = "terraform"
}