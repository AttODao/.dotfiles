{ inputs, pkgs, ... }:
{
  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      calendarSupport = true;
    };

    settings = {
      bar = {
        position = "top";
        density = "default";
      };

      general.avatarImage = "/home/attodao/.face";

      dock = {
        onlySameOutput = false;
        showLauncherIcon = true;
        launcherPosition = "start";
        launcherUseDistroLogo = true;
        groupApps = true;
        groupClickAction = "cycle";
        groupIndicatorStyle = "dots";
        pinnedApps = [
          "Foot Client"
          "PCManFM"
          "Zed"
          "Floorp"
          "An Anime Game Launcher"
          "The Honkers Railway Launcher"
        ];
      };

      appLauncher = {
        customLaunchPrefixEnabled = true;
        customLaunchPrefix = "systemd-run --user --scope --collect --";
      };

      location = {
        name = "Toyoake, Japan";
        use12hourFormat = false;
        useFahrenheit = false;
      };

      nightLight = {
        enabled = true;
        forced = true;
        autoSchedule = false;
        nightTemp = "4000";
        dayTemp = "6500";
      };

      colorSchemes = {
        predefinedScheme = "Gruvbox";
        darkMode = true;
        schedulingMode = "off";
      };
    };
  };
}
