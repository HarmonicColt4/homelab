module "minikube-sandbox" {
  source          = "./modules/cloud-init-vm"
  vm_name         = "minikube-sandbox"
  cloud_image_id  = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
  cloud_init_path = "cloud-inits/cloud-init-minikube-sandbox.yml"
  cpu_cores       = 4
  memory          = 8192
  disk_size       = 40
  username        = var.username
}