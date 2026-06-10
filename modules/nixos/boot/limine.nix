{ pkgs, ... }:
let
  plymouthTheme = pkgs.callPackage ./plymouth-theme { };
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    plymouth = {
      enable = true;
      theme = "attodesk";
      themePackages = [ plymouthTheme ];
    };

    consoleLogLevel = 3;
    initrd = {
      kernelModules = [ "amdgpu" ];
      verbose = false;
    };
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    loader = {
      systemd-boot.enable = false;

      limine = {
        enable = true;
        maxGenerations = 10;
      };

      efi.canTouchEfiVariables = true;
    };
  };
}
