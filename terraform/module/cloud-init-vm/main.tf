terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.51.0"
    }
  }

  required_version = ">=1.7.5"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name

  source_file {
    path = var.cloud_config
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.node_name

  template = var.template

  agent {
    enabled = true
  }

  cpu {
    cores = var.cpu_cores
    units = 100
  }

  memory {
    dedicated = var.memory_size
  }

  disk {
    datastore_id = var.vm_disk_datastore
    file_id      = proxmox_virtual_environment_download_file.cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.disk_size
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ipv4
        gateway = var.gateway
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.node_name

  url = var.cloud_image_url
  overwrite_unmanaged = true
}