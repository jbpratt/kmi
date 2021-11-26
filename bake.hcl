# https://docs.docker.com/engine/reference/commandline/buildx_bake
# FLAG=$(git rev-parse --short HEAD) docker buildx bake -f bake.hcl --builder honeypot --progress tty --load

variable "FLAG" {
  default = "dev"
}

group "default" {
  targets = ["ubuntu"]
}

group "ubuntu" {
  targets = ["ubuntu-1804", "ubuntu-2004", "ubuntu-2110"]
}

target "ubuntu-defaults" {
  dockerfile = "Containerfile"
  platforms = ["linux/arm64", "linux/amd64"]
  args = {
    FLAVOR = "ubuntu",
    PKG_LIST = "screenfetch,python3,tmux,git,vim,net-tools,cloud-init,cloud-initramfs-growroot,qemu-guest-agent"
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