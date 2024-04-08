module "minikube-sandbox-vm" {
  source            = "../module/cloud-init-vm"
  vm_name           = "minikube-sandbox"
  node_name         = "virtual-pve"
  cpu_cores         = 4
  memory_size       = 4096
  disk_size         = 40
  ipv4              = "10.13.25.20/24"
  gateway           = "10.13.25.1"
  cloud_image_url   = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  vm_disk_datastore = "local-lvm"
  cloud_config      = "cloud-inits/cloud-init-minikube-sandbox.yml"
}