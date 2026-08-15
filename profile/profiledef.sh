#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="minos"
iso_label="MINOS_$(date +%Y%m)"
iso_publisher="GroupDev-Web <https://github.com/GroupDev-Web/MinOS>"
iso_application="MinOS rescue and chroot environment"
iso_version="$(date +%Y.%m.%d)"
install_dir="minos"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.grub.esp' 'uefi-x64.grub.esp' 'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
file_permissions=(
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/minos-chroot"]="0:0:755"
  ["/usr/local/bin/minos-help"]="0:0:755"
)

