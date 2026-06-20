# Workflow

## Searching

Use `rg` first:

```bash
rg --files -g '!result/**'
rg 'pattern' -g '!result/**'
```

Avoid searching `result/` unless the task explicitly involves a built system closure.

## Editing

- Use `apply_patch` for manual edits.
- Preserve unrelated user changes.
- Keep modules focused on their existing responsibility.
- Add comments only when they clarify non-obvious behavior.
- New imported files must be added to Git before evaluation:

```bash
git add path/to/new-file.nix
```

## Validation

Use `--no-write-lock-file` for normal checks:

```bash
nix eval --no-write-lock-file --raw .#nixosConfigurations.attodesk.config.system.build.toplevel.drvPath
nix eval --no-write-lock-file --raw .#homeConfigurations.attodao.activationPackage.drvPath
```

For host-specific values:

```bash
nix eval --no-write-lock-file --json .#nixosConfigurations.attodesk.config.networking.hostName
nix eval --no-write-lock-file --json .#homeConfigurations.attodao.config.home.packages
```

For full local builds:

```bash
sudo nixos-rebuild build --flake .#attodesk
home-manager build --flake .#attodao
```

Apply only when requested:

```bash
sudo nixos-rebuild switch --flake .#attodesk
home-manager switch --flake .#attodao
```

## Lock File

`flake.lock` is ignored by Git. Nix may still try to update it during evaluation when inputs are unlocked. Prefer `--no-write-lock-file` unless intentionally updating inputs.

## Risk Areas

- `hardware-configuration.nix`: generated, machine-specific.
- `system.stateVersion` and `home.stateVersion`: do not change casually.
- `/mnt/hdd1` and `/mnt/ssd1`: `attodesk` storage assumptions.
- PAM/login PIN files: test carefully because mistakes can affect login.
- Mail, CalDAV, SSH, and Cloudflare settings: do not add credentials.
