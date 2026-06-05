{
  imports = [
    ./greeter.nix
  ];

  programs = {
    dconf.enable = true;
    niri.enable = true;
  };

  services.gvfs.enable = true;
}
