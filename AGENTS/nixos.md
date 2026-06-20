# NixOS Modules

NixOS configuration is assembled from `hosts/<host>/default.nix`.

## Host Files

- `hosts/attodesk/default.nix`: imports AAGL, hardware config, mounts, shared modules, and login PIN.
- `hosts/attodesk/mounts.nix`: Btrfs mounts for `/mnt/ssd1` and `/mnt/hdd1`, auto scrub, and host storage directories.
- `hosts/attolap/default.nix`: imports shared modules, laptop power services, and login PIN.
- `hosts/attolap/hardware-configuration.nix`: placeholder. Do not treat `attolap` as fully buildable until this is replaced.

## Shared Modules

- `modules/nixos/core/`: Nix settings, locale, networking, users, baseline packages.
- `modules/nixos/boot/`: Limine bootloader and Plymouth theme.
- `modules/nixos/desktop/`: Hyprland system enablement, ReGreet, GVFS, dconf.
- `modules/nixos/hardware/`: PipeWire, Bluetooth, graphics, uinput, Logitech support, game device udev rules.
- `modules/nixos/programs/`: nix-ld, Steam, AppImage, game launchers, zsh.
- `modules/nixos/services/`: system services such as OpenSSH and Evolution Data Server.
- `modules/nixos/security/login-pin.nix`: custom login PIN PAM integration.

## System Rules

- Keep `system.stateVersion = "26.05"` unchanged unless explicitly requested.
- Keep generated `hardware-configuration.nix` files machine-specific.
- Put host-only storage and device configuration in the host directory or behind `hostName` conditionals.
- Do not store passwords, API tokens, account passwords, or private keys in Nix.
- Prefer `systemd.tmpfiles.rules` for system-owned directory creation under mounts such as `/mnt/hdd1`.

## Current Host-Specific Details

- `attodesk` maps `mail.attodao.cc` to `192.168.0.100`.
- `attodesk` uses `/mnt/hdd1` for user data directories and `/mnt/hdd1/nextcloud` for Nextcloud sync.
- `attodesk` has Logitech graphical support, Kando, Solaar, StreamController, and extra launchers.
- `attolap` uses laptop power services: `power-profiles-daemon` and `upower`.
