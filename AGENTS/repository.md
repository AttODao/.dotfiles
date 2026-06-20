# Repository Layout

This is a Nix flake for two NixOS hosts and one Home Manager user.

## Entry Points

- `flake.nix`: defines inputs, `nixosConfigurations`, and `homeConfigurations.attodao`.
- `hosts/<host>/default.nix`: host-specific NixOS module list.
- `modules/nixos/`: shared NixOS modules.
- `home/attodao/default.nix`: Home Manager module list for user `attodao`.
- `home/attodao/`: user-level desktop, program, service, and package configuration.

## Hosts

- `attodesk`: desktop machine. Uses AAGL, extra Btrfs mounts, multi-monitor Hyprland config, Kando, Solaar, Wallpaper Engine, Nextcloud, and game launchers.
- `attolap`: laptop. Uses the shared module set with laptop power services. Its `hardware-configuration.nix` is currently a placeholder until generated on the machine.

Host-specific behavior should usually be expressed with `hostName == "attodesk"` or `hostName == "attolap"` inside shared modules. Add a new host-specific module only when the behavior is large or clearly isolated.

## Important Directories

```text
.
├── flake.nix
├── hosts/
│   ├── attodesk/
│   └── attolap/
├── modules/nixos/
│   ├── boot/
│   ├── core/
│   ├── desktop/
│   ├── hardware/
│   ├── programs/
│   ├── security/
│   └── services/
└── home/attodao/
    ├── desktop/
    ├── programs/
    ├── services/
    ├── default.nix
    └── packages.nix
```

## Flake Notes

- `nixpkgs`, `home-manager`, and `noctalia` track `master`.
- `aagl` is used by `attodesk`.
- `home-manager.useGlobalPkgs = true` and `home-manager.useUserPackages = true` are set in `flake.nix`.
- `hostName` and `inputs` are passed through `specialArgs` and `extraSpecialArgs`.
- `flake.lock` is ignored. Use `--no-write-lock-file` for checks unless the task is explicitly to update inputs.

## Git Hygiene

The worktree may contain user edits. Do not revert or normalize unrelated changes. When adding a file that is imported by Nix, run `git add <file>` before evaluation because flakes ignore untracked imported paths.
