provider "docker" {}

resource "docker_image" "ubuntu" {
  name = "ubuntu:20.04"
}

resource "docker_container" "ubuntu_container" {
  name  = "ubuntu-terraform"
  image = docker_image.ubuntu.name

  ports {
    internal = 22
    external = 2222
  }

  network_mode = "bridge"

  command = [
    "sh", "-c",
    <<-EOT
      apt update &&
      apt install -y openssh-server sudo &&
      mkdir -p /var/run/sshd &&
      echo "PermitRootLogin yes" >> /etc/ssh/sshd_config &&
      echo "root:root" | chpasswd &&
      service ssh start &&
      tail -f /dev/null
    EOT
  ]
}

