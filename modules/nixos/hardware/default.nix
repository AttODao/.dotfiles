{
  imports = [
    ./sound/pipewire.nix
  ];

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
    uinput.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
