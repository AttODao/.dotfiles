{
  config,
  hostName,
  lib,
  pkgs,
  ...
}:
{
  services.linux-wallpaperengine = {
    enable = hostName == "attodesk";
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

  systemd.user.services.linux-wallpaperengine.Service.Environment = lib.mkIf (hostName == "attodesk") [
    "XCURSOR_THEME=Yanfei-Cursors"
    "XCURSOR_SIZE=48"
    "HYPRCURSOR_THEME=Yanfei-Cursors"
    "HYPRCURSOR_SIZE=48"
  ];
}
