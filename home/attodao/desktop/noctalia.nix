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
        pinnedApps = [
          "Foot Client"
          "Dolphin"
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

      colorSchemes.predefinedScheme = "Gruvbox";
    };
  };
}
