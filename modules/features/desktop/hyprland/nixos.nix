{
  imports = [
    ./greeter.nix
  ];

  programs = {
    dconf.enable = true;

    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  services.gvfs.enable = true;
}
