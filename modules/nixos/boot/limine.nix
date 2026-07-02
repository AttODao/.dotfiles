{
  hostName,
  lib,
  pkgs,
  ...
}:
let
  plymouthTheme = pkgs.callPackage ./plymouth-theme { };
  desktopPerformanceKernelParams = lib.optionals (hostName == "attodesk") [
    # Desktop-only throughput tuning.
    "mitigations=off"
    "nowatchdog"
  ];
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    plymouth = {
      enable = true;
      theme = "attodesk";
      themePackages = [ plymouthTheme ];
    };

    consoleLogLevel = 3;
    initrd = {
      kernelModules = if hostName == "attodesk" then [ "amdgpu" ] else [ ];
      verbose = false;
    };
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
    ] ++ desktopPerformanceKernelParams;

    loader = {
      systemd-boot.enable = false;

      limine = {
        enable = true;
        maxGenerations = 10;
      };

      efi.canTouchEfiVariables = true;
    };
  };

  powerManagement = lib.mkIf (hostName == "attodesk") {
    cpuFreqGovernor = "performance";
  };
}
