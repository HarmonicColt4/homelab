variable "vm_name" {
  type = string
}
variable "node_name" {
  type = string
}
variable "cloud_image_url" {
  type = string
}
variable "cloud_config" {
  type = string
}
variable "vm_disk_datastore" {
  type = string
}
variable "ipv4" {
  type = string
  default = "dhcp"
}
variable "gateway" {
  type = string
  default = null
}
variable "cpu_cores" {
  type = number
}
variable "memory_size" {
  type = number
}
variable "disk_size" {
  type = number
}
variable "template" {
  type = bool
  default = false
}
