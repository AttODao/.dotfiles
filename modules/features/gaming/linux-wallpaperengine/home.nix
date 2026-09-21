{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.linux-wallpaperengine;

  wallpaperCommand =
    wallpaper:
    let
      extraOptions = lib.attrByPath [ "extraOptions" ] [ ] wallpaper;
      args = lib.escapeShellArgs (
        lib.cli.toCommandLineGNU { } {
          screen-root = wallpaper.monitor;
          inherit (wallpaper) scaling;
          silent = cfg.audio.silent;
          noautomute = !cfg.audio.automute;
          no-audio-processing = !cfg.audio.processing;
        }
        ++ extraOptions
        ++ [
          "--bg"
          wallpaper.wallpaper
        ]
      );
    in
    ''
      ${lib.getExe cfg.package} \
        ${
          lib.optionalString (cfg.assetsPath != null) "--assets-dir ${lib.escapeShellArg cfg.assetsPath} "
        }\
        ${args} &
    '';

  wallpaperCommands = pkgs.writeShellScriptBin "linux-wallpaperengine-commands" ''
    set -eu
    ${lib.concatStringsSep "\n" (map wallpaperCommand cfg.wallpapers)}
    wait
  '';
in
{
  services.linux-wallpaperengine = {
    enable = true;
    package = pkgs.linux-wallpaperengine;

    assetsPath = "${config.home.homeDirectory}/.local/share/Steam/steamapps/common/wallpaper_engine/assets";
    audio = {
      silent = true;
      processing = false;
    };

    wallpapers = [
      {
        monitor = "HDMI-A-2";
        wallpaper = "2270407932";
        scaling = "fill";
      }
      {
        monitor = "DP-1";
        wallpaper = "2540151267";
        scaling = "fill";
      }
      {
        monitor = "HDMI-A-1";
        wallpaper = "1810612745";
        scaling = "fill";
      }
    ];
  };

  systemd.user.services.linux-wallpaperengine.Service.ExecStart =
    lib.mkForce "${wallpaperCommands}/bin/linux-wallpaperengine-commands";

  systemd.user.services.linux-wallpaperengine.Service.Environment = [
    "XCURSOR_THEME=Yanfei-Cursors"
    "XCURSOR_SIZE=48"
    "HYPRCURSOR_THEME=Yanfei-Cursors"
    "HYPRCURSOR_SIZE=48"
  ];
}
