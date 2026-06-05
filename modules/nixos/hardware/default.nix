{
  imports = [
    ./sound/pipewire.nix
  ];

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };
}
