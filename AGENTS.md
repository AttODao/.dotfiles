# Agent Instructions

This repository manages the personal NixOS and Home Manager setup for `attodao`.

Read these files before making changes:

- `AGENTS/repository.md`: repository layout, entry points, host model
- `AGENTS/nixos.md`: NixOS host and system module rules
- `AGENTS/home-manager.md`: user-level Home Manager rules
- `AGENTS/workflow.md`: edit, validation, and apply commands

Core rules:

- Preserve unrelated local changes. This repository may already be dirty.
- Prefer existing module boundaries and `hostName` conditionals over duplicating configs.
- Do not change `system.stateVersion`, `home.stateVersion`, hardware configs, or secrets unless explicitly asked.
- `flake.lock` and `result` are intentionally ignored; avoid writing lock changes unless requested.
- New files imported by the flake must be added to Git before Nix can evaluate them.
