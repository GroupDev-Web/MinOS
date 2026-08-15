#!/usr/bin/env bash
set -euo pipefail
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash -n "$root_dir/scripts/build.sh"
bash -n "$root_dir/profile/profiledef.sh"
bash -n "$root_dir/profile/airootfs/usr/local/bin/minos-help"
bash -n "$root_dir/profile/airootfs/usr/local/bin/minos-chroot"
grep -qx 'busybox' "$root_dir/profile/packages.x86_64"
grep -qx 'iwd' "$root_dir/profile/packages.x86_64"
grep -qx 'linux' "$root_dir/profile/packages.x86_64"
echo "MinOS source validation passed."
