output "minikube_ip" {
  value = module.minikube-sandbox.vm_ipv4_address
}

output "k3s_ip" {
  value = module.k3s-sandbox.vm_ipv4_address
}