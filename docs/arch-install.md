# Arch install

Using `archinstall`, the guided installer on the ISO. Result: LUKS-encrypted Btrfs root with
Snapper snapshots, systemd-boot, zram swap, NetworkManager, no desktop. `install.sh` from
the dotfiles adds Hyprland and everything else afterwards.

Tailored to this laptop: AMD Ryzen AI 9 HX 370 with Radeon 890M, 64 GiB RAM, NVMe, 64-bit UEFI.
Starts from the booted live ISO.

## 1. Before running the installer

```sh
loadkeys sv-latin1
iwctl device list                      # wi-fi interface name, usually wlan0
iwctl station wlan0 connect <SSID>     # archinstall copies this connection to the installed system
ping -c 3 ping.archlinux.org
pacman -Sy archinstall                 # pick up fixes released after the ISO was built
archinstall
```

## 2. Menu choices

Top to bottom. Anything not listed stays at its default.

- **Archinstall language**: English.
- **Locales**: keyboard layout `sv-latin1`, locale language `en_US`, encoding `UTF-8`.
- **Mirrors and repositories**: select region Sweden. Leave optional repositories off.
- **Disk configuration**:
  - *Partitioning*: `Use a best-effort default partition layout`, pick the NVMe disk.
    Filesystem `btrfs`. `Would you like to use BTRFS subvolumes with a default structure?` Yes.
    `Would you like to use compression or disable CoW?` `Use compression`.
    Separate `/home` partition: No, the `@home` subvolume covers it.
  - *Snapshot type*: `Snapper`. The installer creates `root` and `/home` configs and enables
    the timeline and cleanup timers.
  - *Disk encryption*: encryption type `LUKS`, set the disk passphrase, select the root
    partition. Leave the iteration time at its default. No HSM.
- **Swap**: `Would you like to use swap on zram?` Yes, compression algorithm `zstd`.
- **Bootloader**: `Systemd-boot`. Unified kernel images: No.
- **Hostname**: `<hostname>`.
- **Authentication**: set a root password. Add user account `jimvid` with a password and
  sudo enabled. Passwordless sudo: Disabled.
- **Profile**: type `Minimal`. The dotfiles install the desktop, so skip the Hyprland profile:
  it pulls in kitty, dolphin, wofi, uwsm and polkit-kde-agent that the dotfiles don't use.
- **Applications**: Audio `Pipewire`. Bluetooth: Yes.
- **Kernels**: `linux`.
- **Additional firmware**: none. The Ryzen and Radeon firmware is in `linux-firmware`.
- **Network configuration**: `Use Network Manager (default backend)`. The dotfiles enable it.
- **Additional packages**: `git openssh age zsh`. Enough to fetch the keys and clone.
- **Timezone**: `Europe/Stockholm`.
- **Automatic time sync (NTP)**: Enabled.
- **Install**. Confirm the summary; the disk is wiped at this point.

When it reports it is safe to reboot, decline the chroot offer and `reboot`. Remove the stick,
enter the LUKS passphrase, log in as `jimvid` on the tty.

## 3. First boot: network, keys, dotfiles

The installer copies the ISO's Wi-Fi profile, but bound to the ISO's interface name
(`wlan0`), so on the installed system it fails with "No suitable device found". Delete it and
connect fresh:

```sh
nmcli connection delete "<SSID>"
nmcli device wifi connect "<SSID>" password "<password>"
```

Then follow the README, in its order: decrypt the ssh keys from the USB stick, clone the
dotfiles over ssh, run `install.sh`. The AUR builds make it slow; it is idempotent, so re-run
it if it stops.

## 4. Into Hyprland

```sh
reboot
```

sddm is enabled by `install.sh`; the Hyprland session is the only entry.

## What archinstall produced

Subvolumes `@` at `/`, `@home` at `/home`, `@log` at `/var/log`, `@pkg` at
`/var/cache/pacman/pkg`, mounted with `compress=zstd`. Snapper keeps snapshots in
`/.snapshots` nested inside `@`, and in `/home/.snapshots` inside `@home`. zram is a 16 GiB
compressed swap device from `/etc/systemd/zram-generator.conf`. Logs of the install are in
`/var/log/archinstall/install.log`; mention archinstall if you ever ask for support.

## Rollback (from the live ISO)

```sh
cryptsetup open /dev/nvme0n1p2 root
mount /dev/mapper/root /mnt                               # top level, no subvol option
grep -r '<date>' /mnt/@/.snapshots/*/info.xml             # pick a snapshot number; dates are UTC
mv /mnt/@ /mnt/@.broken
btrfs subvolume snapshot /mnt/@.broken/.snapshots/<n>/snapshot /mnt/@
mv /mnt/@.broken/.snapshots /mnt/@/.snapshots             # keep the snapshot history
umount /mnt && cryptsetup close root && reboot
```

Delete `@.broken` once the restored system is confirmed good.

## Sources

Arch wiki: Archinstall, Installation guide, dm-crypt, Btrfs, Snapper, systemd-boot, Zram,
Hyprland. Menu labels and defaults checked against the archinstall 4.5 source.
