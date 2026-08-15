# MinOS

MinOS is a tiny, terminal-only Arch Linux rescue environment for chrooting into
broken installations and debugging disks, filesystems, bootloaders, and
networks.

## Images

- `MinOS-x86_64.iso` — 64-bit PCs
- `MinOS-i686.iso` — 32-bit x86 PCs

Both images boot directly to a root shell and include:

- Linux and BusyBox
- `arch-chroot`, `mount`, `lsblk`, `blkid`, `fdisk`, and `parted`
- ext4, XFS, Btrfs, FAT, LUKS, LVM, and Linux RAID utilities
- iwd with `iwctl`, plus DHCP through `systemd-networkd`
- `ip`, `ping`, `curl`, `wget`, `dig`, `ss`, and OpenSSH client tools
- GRUB and efibootmgr for boot repair
- nano, vim, less, tmux, git, rsync, and smartmontools

No desktop, display server, browser, installer, or graphical toolkit is
included.

## Connect to Wi-Fi

```console
iwctl
[iwd]# device list
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect YOUR_NETWORK
[iwd]# exit
```

## Chroot into an installed system

```console
lsblk -f
mount /dev/ROOT_PARTITION /mnt
mount /dev/BOOT_PARTITION /mnt/boot   # when applicable
arch-chroot /mnt
```

If the target is not Arch-based, use the generic helper instead:

```console
minos-chroot /mnt
```

## Build

GitHub Actions builds both architectures on every push to `main`. You can also
start **Build MinOS** manually from the Actions tab. Successful runs publish the
ISOs as workflow artifacts; version tags beginning with `v` also publish them
as release assets.

For a local 64-bit build on Arch Linux:

```console
sudo pacman -S --needed archiso
sudo ./scripts/build.sh x86_64
```

The i686 build is performed in an Arch Linux 32 container by the Actions
workflow and needs Docker plus QEMU/binfmt when built on a 64-bit host.

## Warning

MinOS runs as root and intentionally provides low-level disk tools. Verify every
device name before changing partitions, filesystems, encryption, or boot data.

