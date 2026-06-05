{ inputs, ... }:
{
  imports = [
    inputs.aagl.nixosModules.default

    ./hardware-configuration.nix
    ./mounts.nix

    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/locale.nix
    ../../modules/nixos/core/networking.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/core/packages.nix

    ../../modules/nixos/hardware/bluetooth.nix
    ../../modules/nixos/hardware/graphics.nix
    ../../modules/nixos/hardware/sound/pipewire.nix

    ../../modules/nixos/boot/limine.nix
    ../../modules/nixos/desktop/greetd.nix
    ../../modules/nixos/desktop/niri.nix

    ../../modules/nixos/fonts.nix
    ../../modules/nixos/programs/aagl.nix
    ../../modules/nixos/programs/steam.nix
    ../../modules/nixos/programs/zsh.nix
    ../../modules/nixos/services/evolution-data-server.nix
    ../../modules/nixos/services/openssh.nix
  ];

  # ※ インストール時の値から変更しないこと
  system.stateVersion = "26.05";
}
