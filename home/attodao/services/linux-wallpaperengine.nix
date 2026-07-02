{
  config,
  hostName,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.linux-wallpaperengine;

  wallpaperCommand = wallpaper:
    let
      audio = lib.attrByPath [ "audio" ] { } wallpaper;
      extraOptions = lib.attrByPath [ "extraOptions" ] [ ] wallpaper;
      args = lib.escapeShellArgs (
        lib.cli.toGNUCommandLine { } {
          screen-root = wallpaper.monitor;
          inherit (wallpaper) scaling fps;
          silent = lib.attrByPath [ "silent" ] false audio;
          noautomute = !(lib.attrByPath [ "automute" ] true audio);
          no-audio-processing = !(lib.attrByPath [ "processing" ] true audio);
        }
        ++ extraOptions
        ++ [ "--bg" wallpaper.wallpaperId ]
      );
    in
      ''
        ${lib.getExe cfg.package} \
          ${lib.optionalString (cfg.assetsPath != null) "--assets-dir ${lib.escapeShellArg cfg.assetsPath} "}\
          ${args} &
      '';

  wallpaperCommands = pkgs.writeShellScriptBin "linux-wallpaperengine-commands" ''
    set -eu
    ${lib.concatStringsSep "\n" (map wallpaperCommand cfg.wallpapers)}
    wait
  '';
in
lib.mkIf (hostName == "attodesk") {
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
        audio.processing = false;
      }
      {
        monitor = "DP-1";
        wallpaperId = "2540151267";
        scaling = "fill";
        audio.silent = true;
        audio.processing = false;
      }
      {
        monitor = "HDMI-A-1";
        wallpaperId = "1810612745";
        scaling = "fill";
        audio.silent = true;
        audio.processing = false;
      }
    ];
  };

  systemd.user.services.linux-wallpaperengine.Service.ExecStart = lib.mkForce "${wallpaperCommands}/bin/linux-wallpaperengine-commands";

  systemd.user.services.linux-wallpaperengine.Service.Environment = [
    "XCURSOR_THEME=Yanfei-Cursors"
    "XCURSOR_SIZE=48"
    "HYPRCURSOR_THEME=Yanfei-Cursors"
    "HYPRCURSOR_SIZE=48"
  ];
}
