{
  config,
  hostName,
  inputs,
  lib,
  ...
}:
{
  home = {
    username = "attodao";
    homeDirectory = "/home/${config.home.username}";

    # ※ インストール時の値から変更しないこと
    stateVersion = "26.05";
  };

  imports = [
    inputs.noctalia.homeModules.default

    ./packages.nix
    ./desktop/environment.nix
    ./desktop/hyprland.nix
    ./desktop/mozc-ut.nix
    ./desktop/noctalia.nix
    ./desktop/xdg.nix
    ./programs/apps.nix
    ./programs/foot.nix
    ./programs/floorp.nix
    ./programs/open-deck-desktop.nix
    ./programs/pipeasio.nix
    ./programs/prismgh.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/thunderbird.nix
    ./programs/zsh.nix
    ./services/linux-wallpaperengine.nix
    ./services/nextcloud-client.nix
  ]
  ++ lib.optionals (hostName == "attodesk") [
    ./services/kando.nix
    ./services/solaar.nix
  ];

  programs.home-manager.enable = true;
}
