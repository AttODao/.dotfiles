# Home Manager Modules

Home Manager is rooted at `home/attodao/default.nix`.

## Imports

Always wire new user-level modules through `home/attodao/default.nix` unless they are packages only.

Current areas:

- `home/attodao/packages.nix`: general user packages.
- `home/attodao/desktop/`: environment variables, Hyprland, Noctalia, mozc-ut, XDG dirs.
- `home/attodao/programs/`: applications and per-program settings.
- `home/attodao/services/`: user systemd services and desktop-adjacent daemons.

## User Invariants

- User is `attodao`.
- Home directory is `/home/attodao`.
- Keep `home.stateVersion = "26.05"` unchanged unless explicitly requested.
- Secrets are not declared in Home Manager. Accounts may be configured, but passwords should remain interactive or in an external secret store.

## Host Conditionals

Use `hostName` for user-level differences:

- `attodesk`: `/mnt/hdd1` user directories, fixed monitor layout, Kando, Solaar, Wallpaper Engine, Nextcloud, extra game launchers.
- `attolap`: default monitor, home-directory user folders, no desktop-only daemons.

Prefer conditional imports in `home/attodao/default.nix` for full modules, and `lib.optionals` or `lib.mkIf` inside modules for small differences.

## Desktop Notes

- Hyprland config is generated as `hyprlang` with `configType = "hyprlang"`.
- Hyprland startup uses `uwsm app -t service`.
- Noctalia is the shell, bar, dock, launcher, session UI, weather, nightlight, and CalDAV calendar surface.
- Screenshot output is host-specific: `/mnt/hdd1/Pictures/Screenshots` on `attodesk`, `~/Pictures/Screenshots` on `attolap`.
- XDG user directories use `/mnt/hdd1` on `attodesk` and the home directory on `attolap`.

## Programs And Services

- `programs/apps.nix` enables Discord, OBS, Zed, and Prism Launcher.
- `programs/prism-github-mods.nix` installs `prism-github-mods`, a Python helper for GitHub release mods in Prism Launcher instances. It keeps per-instance config under `~/.config/prism-github-mods/`, can import the old Ferium profile on first run, and refreshes tracked GitHub release jars directly from the latest release. It reuses `GITHUB_TOKEN`, `GH_TOKEN`, or `gh auth token` when available so authenticated GitHub access avoids rate limits.
- `programs/ssh.nix` uses `cloudflared access ssh` for selected hosts.
- `programs/thunderbird.nix` defines mail and calendar accounts without passwords.
- `services/nextcloud-client.nix` starts Nextcloud on `attodesk` with the systemd user service and disables the XDG autostart desktop file to avoid duplicate launches:
  - server: `https://cloud.attodao.cc`
  - local directory: `/mnt/hdd1/nextcloud`
- `services/kando.nix` and `services/solaar.nix` are `attodesk` only.
