{
  pkgs,
  ...
}:
{
  hardware.uinput.enable = true;

  services.udev = {
    packages = [
      pkgs.game-devices-udev-rules
    ];
    extraRules = ''
      # Wine bypasses the desktop input stack when it detects DualSense through hidraw.
      KERNEL=="hidraw*", ENV{HID_ID}=="*:0000054C:00000CE6", MODE="0660", GROUP="input", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", GROUP="input", TAG+="uaccess"
    '';
  };
}
