# multipass.tf

resource "local_file" "master_cloudinit" {
  count    = var.master_nodes
  content  = templatefile("${path.module}/cloud-init.yaml.tpl", {
    hostname           = "master-${count.index}"
    ssh_public_key     = file("~/.ssh/id_rsa.pub")
    kubernetes_version = var.kubernetes_version
  })
  filename = "${path.module}/.cloud-init-master-${count.index}.yaml"
}

resource "multipass_instance" "master" {
  count          = var.master_nodes
  name           = "master-${count.index}"
  cpus           = 2
  memory         = "4G"
  disk           = "20G"
  cloudinit_file = local_file.master_cloudinit[count.index].filename

  provisioner "local-exec" {
    command = "while ! multipass exec ${self.name} -- cloud-init status --wait &>/dev/null; do echo 'Waiting for cloud-init to finish on ${self.name}...' && sleep 5; done"
  }
}

resource "local_file" "worker_cloudinit" {
  count    = var.worker_nodes
  content  = templatefile("${path.module}/cloud-init.yaml.tpl", {
    hostname           = "worker-${count.index}"
    ssh_public_key     = file("~/.ssh/id_rsa.pub")
    kubernetes_version = var.kubernetes_version
  })
  filename = "${path.module}/.cloud-init-worker-${count.index}.yaml"
}

resource "multipass_instance" "worker" {
  count          = var.worker_nodes
  name           = "worker-${count.index}"
  cpus           = 2
  memory         = "2G"
  disk           = "20G"
  cloudinit_file = local_file.worker_cloudinit[count.index].filename

  provisioner "local-exec" {
    command = "while ! multipass exec ${self.name} -- cloud-init status --wait &>/dev/null; do echo 'Waiting for cloud-init to finish on ${self.name}...' && sleep 5; done"
  }
}
