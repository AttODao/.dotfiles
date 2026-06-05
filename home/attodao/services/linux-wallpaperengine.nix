{ config, pkgs, ... }:
{
  services.linux-wallpaperengine = {
    enable = true;
    package = pkgs.linux-wallpaperengine;

    assetsPath = "${config.home.homeDirectory}/.local/share/Steam/steamapps/common/wallpaper_engine/assets";

    wallpapers = [
      {
        monitor = "HDMI-A-2";
        wallpaperId = "2270407932";
        scaling = "fill";
        audio.silent = true;
      }
      {
        monitor = "DP-1";
        wallpaperId = "2540151267";
        scaling = "fill";
      }
      {
        monitor = "HDMI-A-1";
        wallpaperId = "1810612745";
        scaling = "fill";
      }
    ];
  };
}
