variable "vm_name" {
  type = string
}

variable "cloud_image_id" {
  type = string
}

variable "ip_cidr" {
  type    = string
  default = "dhcp"
}

variable "cloud_init_path" {
  type = string
}

variable "gateway" {
  type    = string
  default = null
}

variable "disk_size" {
  type = number
}

variable "cpu_cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "username" {
  type = string
}

variable "node_name" {
  type    = string
  default = "pve"
}

variable "disk_location" {
  type    = string
  default = "local-lvm"
}