resource "proxmox_virtual_environment_download_file" "pve_iso" {
  content_type        = "iso"
  datastore_id        = "local"
  node_name           = "pve"
  url                 = "https://enterprise.proxmox.com/iso/proxmox-ve_8.1-2.iso"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_vm" "virtual-pve" {
  name          = "virtual-pve"
  node_name     = "pve"
  scsi_hardware = "virtio-scsi-single"
  started       = true

  agent {
    enabled = true
  }

  cpu {
    cores = 8
    type  = "host"
    units = 100
  }

  memory {
    dedicated = 32768
  }

  disk {
    interface    = "scsi0"
    datastore_id = "vmdisks"
    iothread     = true
    size         = 128
    backup       = false
    file_format  = "raw"
  }

  network_device {
    bridge = "vmbr0"
  }

  # cdrom {
  #   enabled = true
  #   file_id = proxmox_virtual_environment_download_file.pve_iso.id
  # }
}

module "docker-sandbox-vm" {
  source            = "../module/cloud-init-vm"
  vm_name           = "docker-sandbox"
  node_name         = "pve"
  cpu_cores         = 2
  memory_size       = 4096
  disk_size         = 8
  ipv4              = "10.13.25.15/24"
  gateway           = "10.13.25.1"
  cloud_image_url   = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  vm_disk_datastore = "vmdisks"
  cloud_config      = "cloud-inits/cloud-init-docker-sandbox.yml"
}

module "docker-sandbox-vm" {
  source            = "../module/cloud-init-vm"
  vm_name           = "docker-sandbox"
  node_name         = "pve"
  cpu_cores         = 2
  memory_size       = 4096
  disk_size         = 8
  ipv4              = "10.13.25.16/24"
  gateway           = "10.13.25.1"
  cloud_image_url   = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  vm_disk_datastore = "vmdisks"
  cloud_config      = "cloud-inits/cloud-init-docker-sandbox.yml"
}

resource "proxmox_virtual_environment_vm" "production" {
  acpi                = true
  bios                = "ovmf"
  machine             = "q35"
  name                = "production"
  node_name           = "pve"
  protection          = false
  scsi_hardware       = "virtio-scsi-single"
  started             = true
  tablet_device       = true
  tags                = []
  template            = false
  vm_id               = 101

  agent {
    enabled = true
    timeout = "15m"
    trim    = false
    type    = null

  }

  cpu {
    cores        = 8
    type         = "host"
    units        = 100
  }

  disk {
    aio               = "io_uring"
    datastore_id      = "vmdisks"
    discard           = "on"
    file_format       = "raw"
    interface         = "scsi0"
    iothread          = true
    path_in_datastore = "vm-101-disk-0"
    size              = 128
    ssd               = true
  }

  efi_disk {
    datastore_id      = "local-lvm"
    file_format       = "raw"
    pre_enrolled_keys = false
    type              = "4m"
  }

  hostpci {
    device   = "hostpci0"
    id       = "0000:65:00"
    pcie     = true
    rombar   = true
    xvga     = false
  }

  hostpci {
    device   = "hostpci1"
    id       = "0000:17:00"
    pcie     = true
    rombar   = true
    xvga     = false
  }

  memory {
    dedicated = 32768
  }
  
  network_device {
    bridge       = "vmbr0"
    enabled      = true
    firewall     = true
    mac_address  = "BC:24:11:FD:4E:24"
    model        = "virtio"
    mtu          = 0
    queues       = 0
    rate_limit   = 0
    trunks       = null
    vlan_id      = 0
  }

  operating_system {
    type = "l26"
  }

  vga {
    enabled = true
  }
}

resource "proxmox_virtual_environment_vm" "home-assistant" {
  acpi                = true
  bios                = "ovmf"
  name                = "haos12.1"
  node_name           = "pve"
  protection          = false
  scsi_hardware       = "virtio-scsi-pci"
  started             = true
  tablet_device       = false
  tags                = ["proxmox-helper-scripts"]
  template            = false
  vm_id               = 103

  agent {
    enabled = true
  }

  cpu {
    cores        = 2
    type         = "host"
    units        = 100
  }

  disk {
    aio               = "io_uring"
    backup            = true
    cache             = "writethrough"
    datastore_id      = "vmdisks"
    discard           = "on"
    file_format       = "raw"
    file_id           = null
    interface         = "scsi0"
    iothread          = false
    path_in_datastore = "vm-103-disk-1"
    replicate         = true
    size              = 32
    ssd               = true
  }

  efi_disk {
    datastore_id      = "vmdisks"
    file_format       = "raw"
    pre_enrolled_keys = false
    type              = "4m"
  }

  memory {
    dedicated      = 4096
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = false
    enabled      = true
    firewall     = false
    mac_address  = "02:91:1D:29:EA:AA"
    model        = "virtio"
    mtu          = 0
    queues       = 0
    rate_limit   = 0
    vlan_id      = 0
  }

  operating_system {
    type = "l26"
  }

  usb {
    host    = "3-1.2"
    usb3    = false
  }

  vga {
    enabled = true
  }
}
