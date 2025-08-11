# kubeadm/outputs.tf

output "master_vm_names" {
  description = "The names of the master node VMs."
  value       = multipass_instance.master[*].name
}

output "worker_vm_names" {
  description = "The names of the worker node VMs."
  value       = multipass_instance.worker[*].name
}

