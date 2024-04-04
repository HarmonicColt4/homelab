terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }

  required_version = ">=1.7.5"
}

provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_api_token_id = var.PM_API_TOKEN_ID
  pm_api_token_secret = var.PM_API_TOKEN_SECRET
}

resource "proxmox_vm_qemu" "cloud-init-test" {
  name = "test-cloud-init"
  bios = "ovmf"
  target_node = "pve"
  
  clone = "VM 9000"

  vm_state = "stopped"
  boot = "order=scsi0;ide2"
  agent = 1
  memory = 4096
  cores = 4
  cpu = "host"
  scsihw = "virtio-scsi-single"
  os_type = "ubuntu"
  machine = "q35"
  qemu_os = "other"

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          iothread = true
          size = 32
          storage = "vmdisks"
        }
      }
    }
  }

  efidisk {
    efitype = "4m"
    storage = "vmdisks"
  }
} 