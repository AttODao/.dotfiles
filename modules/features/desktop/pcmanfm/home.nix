{
  config,
  hostName,
  lib,
  pkgs,
  ...
}:
let
  homeDirectory = config.home.homeDirectory;
  dataDirectory = if hostName == "attodesk" then "/mnt/hdd1" else homeDirectory;
  pcmanfmDesktopEntry = builtins.replaceStrings [ "@PCMANFM@" ] [ "${pkgs.pcmanfm}/bin/pcmanfm" ] (
    builtins.readFile ./pcmanfm.desktop
  );
  pcmanfmIcon =
    pkgs.runCommandLocal "pcmanfm-icon.png"
      {
        nativeBuildInputs = [ pkgs.librsvg ];
      }
      ''
        rsvg-convert -w 256 -h 256 \
          ${pkgs.papirus-icon-theme}/share/icons/Papirus/64x64/apps/system-file-manager.svg \
          > $out
      '';
in
{
  home.file = lib.mkIf (hostName == "attolap") {
    "Pictures/Screenshots/.keep".text = "";
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${homeDirectory}/Desktop";
      documents = "${dataDirectory}/Documents";
      download = "${dataDirectory}/Downloads";
      music = "${dataDirectory}/Music";
      pictures = "${dataDirectory}/Pictures";
      publicShare = "${homeDirectory}/Public";
      templates = "${homeDirectory}/Templates";
      videos = "${dataDirectory}/Videos";
    };

    dataFile."icons/hicolor/256x256/apps/pcmanfm.png".source = pcmanfmIcon;

    dataFile."applications/pcmanfm.desktop".text = pcmanfmDesktopEntry;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "pcmanfm.desktop";
        "x-directory/normal" = "pcmanfm.desktop";
      };
    };
  };
}
