{ config, inputs, ... }:
{
  home = {
    username = "attodao";
    homeDirectory = "/home/${config.home.username}";

    # ※ インストール時の値から変更しないこと
    stateVersion = "26.05";
  };

  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default

    ./packages.nix
    ./desktop/niri.nix
    ./desktop/noctalia.nix
    ./desktop/xdg.nix
    ./desktop/fcitx5.nix
    ./desktop/session-variables.nix
    ./programs/foot.nix
    ./programs/starship.nix
    ./programs/zsh.nix
    ./services/linux-wallpaperengine.nix
  ];

  programs.home-manager.enable = true;
}
