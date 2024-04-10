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

provider "proxmox" {
  endpoint  = var.pm_endpoint
  insecure  = true
  api_token = "${var.PM_API_TOKEN_ID}=${var.PM_API_TOKEN_SECRET}"
  ssh {
    agent       = false
    username    = local.pve_local_username
    private_key = file("keys/id_rsa")
  }
}
