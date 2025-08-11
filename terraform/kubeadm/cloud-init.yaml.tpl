#cloud-config
hostname: ${hostname}
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_public_key}

package_update: false
package_upgrade: false

runcmd:
  # Overwrite /etc/apt/sources.list to use Aliyun mirrors
  - |
    tee /etc/apt/sources.list <<EOF
    deb https://mirrors.aliyun.com/ubuntu-ports/ noble main restricted universe multiverse
    deb https://mirrors.aliyun.com/ubuntu-ports/ noble-updates main restricted universe multiverse
    deb https://mirrors.aliyun.com/ubuntu-ports/ noble-backports main restricted universe multiverse
    deb https://mirrors.aliyun.com/ubuntu-ports/ noble-security main restricted universe multiverse
    EOF
  # Add Docker GPG key and repository from Aliyun mirror
  - curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  - echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  # Add Kubernetes GPG key and repository from Aliyun mirror
  - curl -fsSL https://mirrors.aliyun.com/kubernetes-new/core:/stable:/v${kubernetes_version}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  - echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://mirrors.aliyun.com/kubernetes-new/core:/stable:/v${kubernetes_version}/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
  # Update apt and install packages
  - apt-get update
  - apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common containerd.io kubelet=${kubernetes_version}-00 kubeadm=${kubernetes_version}-00 kubectl=${kubernetes_version}-00
  # Mark packages to prevent automatic updates
  - apt-mark hold kubelet kubeadm kubectl
