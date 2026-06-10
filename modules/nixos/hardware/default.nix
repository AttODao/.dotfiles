{ pkgs, ... }:
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

  services.udev.packages = [
    pkgs.game-devices-udev-rules
  ];

  services.udev.extraRules = ''
    # Wine needs direct hidraw access for native DualSense detection.
    KERNEL=="hidraw*", ENV{HID_ID}=="*:0000054C:00000CE6", MODE="0660", GROUP="input", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", GROUP="input", TAG+="uaccess"
  '';
}
