#!/usr/bin/env bash
set -euo pipefail

arch="${1:-x86_64}"
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
profile="$root_dir/profile"
work="$root_dir/work/$arch"
out="$root_dir/out"

case "$arch" in
  x86_64)
    command -v mkarchiso >/dev/null || {
      echo "mkarchiso is required (install the archiso package)." >&2
      exit 1
    }
    ;;
  i686)
    command -v mkarchiso >/dev/null || {
      echo "mkarchiso is required inside an Arch Linux 32 environment." >&2
      exit 1
    }
    ;;
  *)
    echo "Usage: $0 {x86_64|i686}" >&2
    exit 2
    ;;
esac

rm -rf "$work"
mkdir -p "$work" "$out"

tmp_profile="$(mktemp -d)"
trap 'rm -rf "$tmp_profile"' EXIT
# Start with ArchISO's maintained bootloader configuration, then apply MinOS.
cp -a /usr/share/archiso/configs/releng/. "$tmp_profile/"
cp -a "$profile/." "$tmp_profile/"
sed -i "s/^arch=.*/arch=\"$arch\"/" "$tmp_profile/profiledef.sh"

# mkarchiso selects packages.${arch}. The x86_64 manifest already has the
# correct name, so only create a second manifest for other architectures.
if [[ "$arch" != x86_64 ]]; then
  cp "$tmp_profile/packages.x86_64" "$tmp_profile/packages.$arch"
fi

# Git cannot represent symlinks reliably through every connector, so create the
# service enablement links in the disposable profile.
for unit in iwd.service systemd-networkd.service systemd-resolved.service; do
  link="$tmp_profile/airootfs/etc/systemd/system/multi-user.target.wants/$unit"
  rm -f "$link"
  ln -s "/usr/lib/systemd/system/$unit" "$link"
done

if [[ "$arch" == i686 ]]; then
  # Arch Linux 32 uses BIOS boot for broad 32-bit hardware compatibility.
  sed -i "s/^bootmodes=.*/bootmodes=('bios.syslinux')/" "$tmp_profile/profiledef.sh"
fi

mkarchiso -v -w "$work" -o "$out" "$tmp_profile"

built="$(find "$out" -maxdepth 1 -type f -name '*.iso' -printf '%T@ %p\n' | sort -nr | head -1 | cut -d' ' -f2-)"
[[ -n "$built" ]] || { echo "No ISO was produced" >&2; exit 1; }
final="$out/MinOS-$arch.iso"
mv -f "$built" "$final"
(cd "$out" && sha256sum "$(basename "$final")" > "$(basename "$final").sha256")
echo "Built $final"
