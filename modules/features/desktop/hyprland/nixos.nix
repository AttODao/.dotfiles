{ hostName, lib, ... }:
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

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "ignore";
  } // lib.optionalAttrs (hostName == "attolap") {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  services.gvfs.enable = true;
}
