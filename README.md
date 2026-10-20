# Dotfiles

Arch Linux + Hyprland. Installing Arch itself: [docs/arch-install.md](docs/arch-install.md). Then:

```sh
sudo pacman -S --needed age openssh git
lsblk                                                  # find the usb stick, e.g. sda1
sudo mount --mkdir /dev/sda1 /mnt/usb
install -d -m 700 ~/.ssh && age -d /mnt/usb/ssh-keys.tar.age | tar -C ~/.ssh -xf - && chmod 600 ~/.ssh/id_ed25519
sudo umount /mnt/usb
git clone git@github.com:Jimvid/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

The ssh keys live on a USB stick as one age-encrypted tarball, not in this repo.
Refresh it with `tar -C ~/.ssh -cf - id_ed25519 id_ed25519.pub | age -p -o /mnt/usb/ssh-keys.tar.age`.

`install.sh` runs the scripts in `install/` in order (packages, yay, AUR, services,
symlinks, desktop settings, tools, zsh, node). Every step is idempotent, so both
`install.sh` and `symlink.sh` can be re-run at any time. `install.sh --skip-docker-desktop`
installs plain docker with the compose and buildx plugins instead of Docker Desktop;
re-running with or without the flag switches between the two.

`symlink.sh` links each entry in its `links` array into `$HOME`. Anything already
there that is not a symlink is moved aside as `*.bak`, never overwritten.

## After the first login

- `fprintd-enroll` once, on a machine with a fingerprint reader. hyprlock then accepts a
  finger as well as the password. Without a reader it just never triggers.
- Sign in to 1Password, Slack, Chrome and `gh auth login`; `fvm install <version>` and
  `fvm global <version>` for Flutter.

Wallpapers live in `wallpapers/`. `wallpaper.sh <image>` sets both the desktop and the login screen.
