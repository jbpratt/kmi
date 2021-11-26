# https://docs.docker.com/engine/reference/commandline/buildx_bake
# FLAG=$(git rev-parse --short HEAD) docker buildx bake --file preview/bake.hcl

variable "FLAG" {
  default = "dev"
}

group "default" {
  targets = ["ubuntu-2004"]
}

group "ubuntu" {
  targets = ["ubuntu-1804", "ubuntu-2004", "ubuntu-2110"]
}

group "fedora" {
  targets = ["fedora-34", "fedora-35"]
}

group "centos-stream" {
  targets = ["centos-stream-8", "centos-stream-9"]
}

target "ubuntu-defaults" {
  dockerfile = "Containerfile"
  platforms = ["linux/arm64"]
  args = {
    FLAVOR = "ubuntu",
    PKG_LIST = "screenfetch,python3,tmux,git,vim,net-tools,cloud-init,cloud-initramfs-growroot,qemu-guest-agent"
  }
}

target "fedora-defaults" {
  dockerfile = "Containerfile"
  platforms = ["linux/amd64"]
  args = {
    FLAVOR = "fedora",
  }
}

target "centos-stream-defaults" {
  dockerfile = "Containerfile"
  platforms = ["linux/amd64"]
  args = {
    FLAVOR = "centos-stream",
  }
}

target "ubuntu-1804" {
  inherits = ["ubuntu-defaults"]
  tags = [
    "docker.io/containercraft/ubuntu:1804-${FLAG}",
    "docker.io/containercraft/ubuntu:bionic-${FLAG}"
  ]
  args = {
    VERSION = "1804"
  }
}

target "ubuntu-2004" {
  inherits = ["ubuntu-defaults"]
  platforms = ["linux/arm64"]
  tags = [
    "docker.io/containercraft/ubuntu:2004-${FLAG}",
    "docker.io/containercraft/ubuntu:focal-${FLAG}"
  ]
  args = {
    VERSION = "2004"
  }
}

target "ubuntu-2110" {
  inherits = ["ubuntu-defaults"]
  tags = [
    "docker.io/containercraft/ubuntu:2110-${FLAG}",
    "docker.io/containercraft/ubuntu:impish-${FLAG}"
  ]
  args = {
    VERSION = "2110"
  }
}

target "fedora-34" {
  inherits = ["fedora-defaults"]
  tags = [
    "docker.io/containercraft/fedora:34-${FLAG}",
  ]
  args = {
    VERSION = "34"
  }
}

target "fedora-35" {
  inherits = ["fedora-defaults"]
  tags = [
    "docker.io/containercraft/fedora:35-${FLAG}",
  ]
  args = {
    VERSION = "35"
  }
}

target "arch" {
  dockerfile = "Containerfile"
  platforms = ["linux/amd64"]
  tags = [
    "docker.io/containercraft/arch:latest-${FLAG}",
  ]
  args = {
    FLAVOR = "arch"
    VERSION = "latest"
  }
}

target "centos-stream-8" {
  inherits = ["centos-stream-defaults"]
  tags = [
    "docker.io/containercraft/centos-stream:8-${FLAG}",
  ]
}

target "centos-stream-9" {
  inherits = ["centos-stream-defaults"]
  tags = [
    "docker.io/containercraft/centos-stream:9-${FLAG}",
  ]
}
