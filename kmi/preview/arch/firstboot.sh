#!/bin/bash -ex
# sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=\"/&console=ttyS0 /' /etc/default/grub
# grub-mkconfig -o /boot/grub/grub.cfg
pacman-key --init
pacman-key --populate
pacman --noconfirm -Syu
pacman --noconfirm -S ${PKG_LIST}
